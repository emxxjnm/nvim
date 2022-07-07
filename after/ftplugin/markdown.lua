local null_ls = require("null-ls")
local service = require("mvim.lsp.service")

service.register_sources({
  { command = "markdownlint" },
}, null_ls.methods.FORMATTING)

service.register_sources({
  { command = "markdownlint" },
}, null_ls.methods.DIAGNOSTICS)
