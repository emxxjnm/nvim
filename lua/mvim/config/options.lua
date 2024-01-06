vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Enable auto format
vim.g.autoformat = true

local opt = vim.opt
local icons = mo.styles.icons
local settings = mo.settings

opt.confirm = true
opt.autowrite = true -- new

opt.pumheight = 12
opt.winminwidth = 5 -- new
opt.wildoptions = "pum"
opt.wildmode = "longest:full,full"
opt.completeopt = "menu,menuone,noselect"

opt.grepprg = "rg --vimgrep"
opt.grepformat = "%f:%l:%c:%m"
opt.formatoptions = "jcroqlnt" -- tcqj

opt.scrolloff = 7
opt.sidescrolloff = 5

-- split
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "screen" -- new

-- display
opt.wrap = false
opt.termguicolors = true
opt.signcolumn = "yes"
opt.smartcase = true
opt.ignorecase = true
opt.virtualedit = "block" -- new
opt.shortmess:append({ W = true, I = true, c = true, C = true })

-- opt.list = true -- new
opt.fillchars = {
  eob = " ",
  fold = " ",
  msgsep = " ",
  foldsep = " ",
  foldopen = icons.documents.expanded,
  foldclose = icons.documents.collapsed,
}

-- fold
opt.foldlevel = 99
opt.foldcolumn = "auto"
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"

opt.laststatus = 0 -- 3
opt.showcmd = false
opt.showmode = false

opt.clipboard = "unnamedplus"

opt.cursorline = true
opt.cursorlineopt = mo.styles.transparent and "number" or "number,line"

-- indent
opt.expandtab = true
opt.smartindent = true -- new
opt.shiftround = true
opt.shiftwidth = 2
opt.tabstop = 2 -- new

-- number
opt.number = true
opt.relativenumber = true

-- time
opt.timeoutlen = 300 -- 500
opt.updatetime = 200 -- 500

-- cache
opt.undofile = true
opt.undodir = { settings.undodir }

opt.swapfile = true
opt.directory = { settings.swapdir }

opt.backup = true
opt.backupdir = { mo.settings.backupdir }
