require("mvim.lsp.manager").setup("gopls")

local opt = vim.api.nvim_set_option_value

opt("expandtab", false, { scope = "local" })
opt("tabstop", 4, { scope = "local" })
opt("shiftwidth", 4, { scope = "local" })
opt("softtabstop", 4, { scope = "local" })
