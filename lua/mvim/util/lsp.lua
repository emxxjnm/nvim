local Util = require("mvim.util")

---@class mvim.util.lsp
local M = {}

---@enum
---@source https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#serverCapabilities
M.providers = {
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
  Util.augroup("LspOnAttach", {
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
  local settings =
    string.format("%s/%s/settings.json", client.workspace_folders[1].name, mo.settings.metadir)
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
    Util.has("cmp-nvim-lsp") and require("cmp_nvim_lsp").default_capabilities() or {},
    Util.has("nvim-ufo")
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

return M
