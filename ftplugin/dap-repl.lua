local opt = vim.opt_local

opt.buflisted = false
opt.winfixheight = true
opt.signcolumn = "yes"

vim.api.nvim_win_set_height(0, math.max(math.min(vim.fn.line("$"), 15), 10))

-- Add autocompletion
require("dap.ext.autocompl").attach()
