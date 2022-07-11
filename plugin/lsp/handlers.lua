local lsp = vim.lsp
local fmt = string.format
local diagnostic = vim.diagnostic
local sign_define = vim.fn.sign_define

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
    header = "",
    source = true,
    focusable = false,
    -- border = "rounded",
    prefix = function(d, i)
      local level = diagnostic.severity[d.severity]
      local prefix = fmt("%d. %s ", i, icons[level:lower()])
      return prefix, "Diagnostic" .. level
    end,
  },
}

local function sign(name, icon)
  sign_define(name, { text = icon, texthl = name })
end

sign("DiagnosticSignHint", icons.hint)
sign("DiagnosticSignInfo", icons.info)
sign("DiagnosticSignWarn", icons.warn)
sign("DiagnosticSignError", icons.error)

diagnostic.config(config)

lsp.handlers["textDocument/hover"] = lsp.with(lsp.handlers.hover, {
  border = "rounded",
})
