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

local config = {
  signs = true,
  underline = true,
  severity_sort = true,
  virtual_text = false,
  update_in_insert = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    prefix = function(d, i)
      local level = diagnostic.severity[d.severity]
      local prefix = fmt("%d. %s ", i, icons[level:lower()])
      return prefix, "Diagnostic" .. level
    end,
  },
}

local function sign(name, icon)
  fn.sign_define(name, { text = icon, texthl = name })
end

function M.setup()
  sign("DiagnosticSignHint", icons.hint)
  sign("DiagnosticSignInfo", icons.info)
  sign("DiagnosticSignWarn", icons.warn)
  sign("DiagnosticSignError", icons.error)

  diagnostic.config(config)

  lsp.handlers["textDocument/hover"] = lsp.with(lsp.handlers.hover, {
    border = "rounded",
  })
end

return M
