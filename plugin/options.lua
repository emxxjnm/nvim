local o, opt = vim.o, vim.opt
local icons = mo.style.icons

-- Indentation
o.wrap = false
o.textwidth = 100

o.expandtab = true
o.shiftwidth = 2
o.shiftround = true

o.smartindent = true

-- line
o.number = true
o.relativenumber = true

o.cursorline = true

-- fold
o.foldlevel = 99
-- o.foldcolumn = "1"
o.foldmethod = "expr"
o.foldexpr = "nvim_treesitter#foldexpr()"

-- display
o.signcolumn = "yes"

o.fileencoding = "UTF-8"

-- opt.clipboard = "unnamedplus"

o.termguicolors = true

o.laststatus = 3

o.scrolloff = 7
o.sidescrolloff = 5

o.pumheight = 12

o.completeopt = "menuone,noselect"

o.confirm = true

opt.fillchars = {
  eob = " ",
  fold = " ",
  foldsep = " ",
  foldopen = icons.documents.expanded,
  foldclose = icons.documents.collapsed,
}

-- Wild in command mode
o.showcmd = false

o.showmode = false

o.cmdheight = 1

o.wildoptions = "pum"
o.wildignorecase = true
o.wildmode = "longest:full,full"

-- match and search
o.incsearch = true
o.smartcase = true
o.ignorecase = true

-- Timings
o.timeoutlen = 500
o.updatetime = 500

-- Window splitting
o.splitright = true
o.splitbelow = true

-- Backup and Swap
o.swapfile = true
o.directory = mo.config.swapdir

o.undofile = true
o.undodir = mo.config.undodir

o.backup = true
o.backupdir = mo.config.backupdir

-- Message output on vim actions
opt.shortmess = {
  f = true,
  s = true,
  o = true,
  O = true,
  t = true,
  T = true,
  A = true,
  c = true,
  F = true,
}
