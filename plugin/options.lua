local opt, fn = vim.opt, vim.fn

local undo_dir = fn.stdpath("cache") .. "/undo"
local swap_dir = fn.stdpath("cache") .. "/swap"
local backup_dir = fn.stdpath("cache") .. "/backup"

-- Indentation
opt.wrap = false
opt.textwidth = 100
opt.autoindent = true
opt.shiftwidth = 2
opt.expandtab = true
opt.shiftround = true

-- line
opt.number = true
opt.relativenumber = true
opt.cursorline = true

-- fold
opt.foldlevel = 99
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"

-- display
opt.signcolumn = "yes"
-- opt.clipboard = "unnamedplus"
opt.termguicolors = true
opt.laststatus = 3
opt.showmode = false
opt.scrolloff = 7
opt.sidescrolloff = 5
opt.pumheight = 12
opt.confirm = true
opt.completeopt = "menuone,noselect"

-- Wild in command mode
opt.cmdheight = 1
-- opt.pumblend = 5
opt.wildoptions = "pum"
opt.wildignorecase = true

-- match and search
opt.incsearch = true
opt.smartcase = true
opt.ignorecase = true

-- Timings
opt.timeoutlen = 500
opt.updatetime = 500

-- Window splitting
opt.splitright = true
opt.splitbelow = true

-- Backup and Swap
opt.backup = true
opt.swapfile = true
opt.undofile = true
opt.undodir = undo_dir
opt.directory = swap_dir
opt.backupdir = backup_dir

-- Format
opt.formatoptions = "12qcrntjlv"

-- Message output on vim actions
opt.shortmess = "AoOtTfFscW"
