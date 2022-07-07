-- start lsp server
require("mvim.lsp.manager").setup("pylsp")

local null_ls = require("null-ls")

-- use ftplugin
local service = require("mvim.lsp.service")

service.register_sources({
  { command = "isort" },
}, null_ls.methods.FORMATTING)

service.register_sources({
  { command = "mypy" },
}, null_ls.methods.DIAGNOSTICS)

-- options
local opt = vim.api.nvim_set_option_value
opt("tabstop", 4, { scope = "local" })
opt("shiftwidth", 4, { scope = "local" })
opt("softtabstop", 4, { scope = "local" })
