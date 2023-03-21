local M = {}

local fmt = string.format

-------------------------------------------------------------------------------
-- Augroup
-------------------------------------------------------------------------------
---@class AutocmdArgs
---@field id number
---@field event string
---@field group string?
---@field buf number
---@field file string
---@field match string | number
---@field data any

---@class Autocommand
---@field desc string
---@field event  string | string[] autocommand events
---@field pattern string | string[] autocommand patterns
---@field command string | fun(args: AutocmdArgs): boolean?
---@field nested  boolean
---@field once    boolean
---@field buffer  number

---Create an autocommand
---returns the group ID so that it can be cleared or maipulated.
---@param name string The name of the autocommand group
---@param ... Autocommand A list of autocommands to create
---@return number augroup id
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
--@param name string augroup name
function M.clear_augroup(name)
  vim.schedule(function()
    pcall(function()
      vim.api.nvim_clear_autocmds({ group = name })
    end)
  end)
end

---@param plugin string
function M.has(plugin)
  return require("lazy.core.config").plugins[plugin] ~= nil
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

---@param func fun(client, buffer)
function M.on_attach(func)
  M.augroup("LspSetupCommands", {
    event = "LspAttach",
    command = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      func(client, buffer)
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

function M.common_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  -- Tell the server the capability of foldingRange :: nvim-ufo
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }
  return require("cmp_nvim_lsp").default_capabilities(capabilities)
end

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

---@param scope "workspace" | "document"
function M.lsp_symbols(scope)
  -- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#symbolKind
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

return M
