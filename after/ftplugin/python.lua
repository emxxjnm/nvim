-- start lsp server
require("mvim.lsp.manager").setup("pylsp")

-- options
local opt = vim.api.nvim_set_option_value
opt("tabstop", 4, { scope = "local" })
opt("shiftwidth", 4, { scope = "local" })
opt("softtabstop", 4, { scope = "local" })
