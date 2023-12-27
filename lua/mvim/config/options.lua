vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Enable auto format
vim.g.autoformat = true

local opt = vim.opt
local icons = mo.styles.icons
local settings = mo.settings

opt.autowrite = true -- new

opt.clipboard = "unnamedplus"
opt.completeopt = "menu,menuone,noselect"
opt.confirm = true
opt.cursorline = true
opt.cursorlineopt = mo.styles.transparent and "number" or "number,line"
opt.expandtab = true
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true
opt.laststatus = 0 -- 3
-- opt.list = true -- new
opt.number = true
opt.relativenumber = true
opt.pumheight = 12
opt.scrolloff = 7
opt.sidescrolloff = 5
opt.sessionoptions = {
  "buffers",
  "curdir",
  "tabpages",
  "winsize",
  "help",
  "globals",
  "skiprtp",
  "folds",
}
opt.shiftround = true
opt.shiftwidth = 2
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.showmode = false
opt.signcolumn = "yes"
opt.smartcase = true
opt.smartindent = true -- new
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "screen" -- new
opt.tabstop = 2 -- new
opt.termguicolors = true
opt.timeoutlen = 300 -- 500
opt.updatetime = 200 -- 500
opt.virtualedit = "block" -- new
opt.wildmode = "longest:full,full"
opt.winminwidth = 5 -- new
opt.wrap = false
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

opt.showcmd = false

opt.wildoptions = "pum"

opt.undofile = true
opt.undodir = { settings.undodir }

opt.swapfile = true
opt.directory = { settings.swapdir }

opt.backup = true
opt.backupdir = { mo.settings.backupdir }
