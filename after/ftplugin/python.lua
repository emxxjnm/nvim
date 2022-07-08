-- start lsp server
require("mvim.lsp.manager").setup("pylsp")

-- options
vim.api.nvim_set_option_value("shiftwidth", 4, { scope = "local" })

local null_ls = require("null-ls")
local service = require("mvim.lsp.service")

service.register_sources({
  { command = "isort" },
}, null_ls.methods.FORMATTING)

service.register_sources({
  { command = "mypy" },
}, null_ls.methods.DIAGNOSTICS)
