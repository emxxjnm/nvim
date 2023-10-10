local M = {}

local fmt = string.format

-------------------------------------------------------------------------------
-- Augroup
-------------------------------------------------------------------------------
---@class AutocmdArgs
---@field id number
---@field event string
---@field group? string
---@field buf number
---@field file string
---@field match string | number
---@field data any

---@class Autocommand
---@field desc? string
---@field event  string | string[] autocommand events
---@field pattern? string | string[] autocommand patterns
---@field command string | fun(args: AutocmdArgs): boolean?
---@field nested?  boolean
---@field once?    boolean
---@field buffer?  number

---Create an autocommand
---returns the group ID so that it can be cleared or maipulated.
---@param name string The name of the autocommand group
---@param ... Autocommand A list of autocommands to create
---@return number augroup_id
function M.augroup(name, ...)
  local commands = { ... }
  assert(name ~= "User", "The name of an augroup CANNOT be User")
  assert(#commands > 0, fmt("You must specify at least on autocommand for %s", name))
  local group_id = vim.api.nvim_create_augroup(name, { clear = true })
  for _, autocmd in ipairs(commands) do
    local is_callback = type(autocmd.command) == "function"
    vim.api.nvim_create_autocmd(autocmd.event, {
      group = group_id,
      pattern = autocmd.pattern,
      desc = autocmd.desc,
      callback = is_callback and autocmd.command or nil,
      command = not is_callback and autocmd.command or nil,
      once = autocmd.once,
      nested = autocmd.nested,
      buffer = autocmd.buffer,
    })
  end
  return group_id
end

---Clean autocommand in a group if it exists
---This is safer than trying to delete the augroup itself
---@param name string augroup name
function M.clear_augroup(name)
  vim.schedule(function()
    pcall(function()
      vim.api.nvim_clear_autocmds({ group = name })
    end)
  end)
end

---Check if the plugin exists
---@param plugin string plugin name
---@return boolean
function M.has(plugin)
  return require("lazy.core.config").spec.plugins[plugin] ~= nil
end

---Get the specified plugin opts
---@param name string plugin name
---@return table plugin_opts
function M.opts(name)
  local plugin = require("lazy.core.config").plugins[name]
  if not plugin then
    return {}
  end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

---Execute code when a plugin loads
---@param name string plugin name
---@param fn fun(name: string)
function M.on_load(name, fn)
  local Config = require("lazy.core.config")
  if Config.plugins[name] and Config.plugins[name]._.loaded then
    fn(name)
  else
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyLoad",
      callback = function(args)
        if args.data == name then
          fn(name)
          return true
        end
      end,
    })
  end
end

---@param silent boolean?
---@param values? {[1]:any, [2]:any}
function M.toggle(option, silent, values)
  if values then
    if vim.opt_local[option]:get() == values[1] then
      vim.opt_local[option] = values[2]
    else
      vim.opt_local[option] = values[1]
    end
    return vim.notify("Set " .. option .. " to " .. vim.opt_local[option]:get())
  end
  vim.opt_local[option] = not vim.opt_local[option]:get()
  if not silent then
    if vim.opt_local[option]:get() then
      vim.notify("Enabled " .. option)
    else
      vim.notify("Disabled " .. option, vim.log.levels.WARN)
    end
  end
end

---list providers
---@param filetype string filetype
---@return table providers null-ls providers
function M.list_registered_providers_names(filetype)
  local sources = require("null-ls.sources")
  local available_sources = sources.get_available(filetype)
  local registered = {}
  for _, source in ipairs(available_sources) do
    for method in pairs(source.methods) do
      registered[method] = registered[method] or {}
      table.insert(registered[method], source.name)
    end
  end
  return registered
end

---list registered formatters
---@param filetype string filetype
---@return string[] providers name of the providers
function M.list_registered_formatters(filetype)
  local method = require("null-ls").methods.FORMATTING
  local providers = M.list_registered_providers_names(filetype)
  return providers[method] or {}
end

---list registered linters
---@param filetype string filetype
---@return string[] providers name of the providers
function M.list_registered_linters(filetype)
  local nls = require("null-ls")
  local providers = M.list_registered_providers_names(filetype)
  local names = vim.tbl_flatten(vim.tbl_map(function(m)
    return providers[m] or {}
  end, {
    nls.methods.DIAGNOSTICS,
    nls.methods.DIAGNOSTICS_ON_OPEN,
    nls.methods.DIAGNOSTICS_ON_SAVE,
  }))
  return names
end

--- LSP utils

---@enum
-- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#serverCapabilities
M.lsp_providers = {
  HOVER = "textDocument/hover",
  RENAME = "textDocument/rename",
  CODELENS = "textDocument/codeLens",
  REFERENCES = "textDocument/references",
  CODEACTION = "textDocument/codeAction",
  DEFINITION = "textDocument/definition",
  DECLARATION = "textDocument/declaration*",
  IMPLEMENTATION = "textDocument/implementation*",
  HIGHLIGHT = "textDocument/documentHighlight",
  SIGNATUREHELP = "textDocument/signatureHelp",
  FORMATTING = "textDocument/formatting",
  RANGEFORMATTING = "textDocument/rangeFormatting",
}

---Setup lsp autocmds
---@param func fun(client, buffer)
function M.on_attach(func)
  M.augroup("LspSetupCommands", {
    event = "LspAttach",
    command = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client then
        func(client, buffer)
      end
    end,
    desc = "Setup the language server autocommands",
  })
end

---This function allows reading a per project `settings.josn` file
---in the `.vim` directory of the project
---@param client table<string, any> lsp client
---@return boolean
function M.common_on_init(client)
  local settings = fmt("%s/%s/settings.json", client.workspace_folders[1].name, mo.settings.metadir)
  if vim.fn.filereadable(settings) == 0 then
    return true
  end

  local ok, json = pcall(vim.fn.readfile, settings)
  if not ok then
    vim.notify_once("LSP init: read file `settings.json` failed", vim.log.levels.ERROR)
    return true
  end

  local status, overrides = pcall(vim.json.decode, table.concat(json, "\n"))
  if not status then
    vim.notify_once("LSP init: unmarshall `settings.json` file failed", vim.log.levels.ERROR)
    return true
  end

  for name, config in pairs(overrides or {}) do
    if name == client.name then
      client.config = vim.tbl_deep_extend("force", client.config, config)
      client.notify("workspace/didChangeConfiguration")

      vim.schedule(function()
        local path = vim.fn.fnamemodify(settings, ":~:.")
        local msg = "loaded local settings for " .. client.name .. " from " .. path
        vim.notify_once(msg, vim.log.levels.INFO)
      end)
    end
  end
  return true
end

---LSP capabilities
---@return table capabilities
function M.common_capabilities()
  return vim.tbl_deep_extend(
    "force",
    vim.lsp.protocol.make_client_capabilities(),
    M.has("cmp-nvim-lsp") and require("cmp_nvim_lsp").default_capabilities() or {},
    M.has("nvim-ufo")
        and {
          textDocument = {
            foldingRange = {
              dynamicRegistration = false,
              lineFoldingOnly = true,
            },
          },
        }
      or {}
  )
end

---Resolve lsp config
---@param name string lsp server name
---@param ... table a list lsp config
---@return table config lsp config
function M.resolve_config(name, ...)
  local defaults = {
    on_init = M.common_on_init,
    capabilities = M.common_capabilities(),
  }

  local has_provider, cfg = pcall(require, "mvim.plugins.lsp.providers." .. name)
  if has_provider then
    defaults = vim.tbl_deep_extend("force", defaults, cfg) or {}
  end

  defaults = vim.tbl_deep_extend("force", defaults, ...) or {}

  return defaults
end

---https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#symbolKind
---@param scope "workspace" | "document"
function M.lsp_symbols(scope)
  local symbols = {
    "File",
    "Module",
    "Namespace",
    "Package",
    "Class",
    "Method",
    "Property",
    "Field",
    "Constructor",
    "Enum",
    "Interface",
    "Function",
    "Variable",
    "Constant",
    "String",
    "Number",
    "Boolean",
    "Array",
    "Object",
    "Key",
    "Null",
    "EnumMember",
    "Struct",
    "Event",
    "Operator",
    "TypeParameter",
  }
  return function()
    vim.ui.select(symbols, { prompt = "Select which symbol" }, function(item)
      if scope == "workspace" then
        require("telescope.builtin").lsp_workspace_symbols({ query = item })
      else
        require("telescope.builtin").lsp_document_symbols({ symbols = item })
      end
    end)
  end
end

-- Find files or live grep in the directory where the cursor is located
-- Or in the directory where the file under the cursor is located
---@param action "find" | "grep"
function M.find_or_grep(action, state)
  if M.has("telescope.nvim") then
    local node = state.tree:get_node()
    local path = node.type == "file" and node:get_parent_id() or node:get_id()

    local prompt = string.format(
      action == "grep" and "Live Grep in %s" or "Find Files in %s",
      require("telescope.utils").transform_path({ path_display = { "shorten" } }, path)
    )
    local func = action == "grep" and require("telescope").extensions.live_grep_args.live_grep_args
      or require("telescope.builtin").find_files

    func({
      cwd = path,
      prompt_title = prompt,
      search_dirs = { path },
      attach_mappings = function(prompt_bufnr)
        local actions = require("telescope.actions")
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local action_state = require("telescope.actions.state")
          local selection = action_state.get_selected_entry()
          local filename = selection.filename
          if filename == nil then
            filename = selection[1]
          end
          require("neo-tree.sources.filesystem").navigate(state, state.path, filename)
        end)
        return true
      end,
    })
  end
end

---@param from string
---@param to string
function M.on_renamed(from, to)
  local clients = vim.lsp.get_active_clients()
  for _, client in ipairs(clients) do
    if client.supports_method("workspace/willRenameFiles") then
      local resp = client.request_sync("workspace/willRenameFiles", {
        files = {
          {
            oldUri = vim.uri_from_fname(from),
            newUri = vim.uri_from_fname(to),
          },
        },
      }, 1000, 0)
      if resp and resp.result ~= nil then
        vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding)
      end
    end
  end
end

return M
