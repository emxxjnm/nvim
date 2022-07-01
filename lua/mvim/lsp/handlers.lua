local M = {}

local lsp = vim.lsp
local fn = vim.fn
local fmt = string.format
local diagnostic = vim.diagnostic

local icons = {
  error = "",
  warn = "",
  hint = "",
  info = "",
}

local function sign(name, icon)
  fn.sign_define(name, { text = icon, texthl = name })
end

function M.setup()
  sign("DiagnosticSignHint", icons.hint)
  sign("DiagnosticSignInfo", icons.info)
  sign("DiagnosticSignWarn", icons.warn)
  sign("DiagnosticSignError", icons.error)

  local config = {
    signs = true,
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    virtual_text = {
      spacing = 1,
      prefix = "",
      format = function(d)
        local level = diagnostic.severity[d.severity]
        return fmt("%s %s", icons[level:lower()], d.message)
      end,
    },
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
      format = function(d)
        local t = vim.deepcopy(d)
        local code = d.code or (d.user_data and d.user_data.lsp.code)
        if code then
          t.message = fmt("%s [%s]", t.message, code):gsub("1. ", "")
        end
        return t.message
      end,
    },
  }

  diagnostic.config(config)

  lsp.handlers["textDocument/hover"] = lsp.with(lsp.handlers.hover, {
    border = "rounded",
  })
end

return M
