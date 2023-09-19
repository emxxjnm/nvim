local o, opt = vim.o, vim.opt
local icons = mo.styles.icons
local settings = mo.settings

-- Indentation
o.wrap = false

o.expandtab = true
o.shiftwidth = 2
o.shiftround = true

-- line
o.number = true
o.relativenumber = true

o.cursorline = true
o.cursorlineopt = mo.styles.transparent and "number" or "number,line"

-- fold
o.foldlevel = 99
o.foldcolumn = "auto"
o.foldmethod = "expr"
o.foldexpr = "nvim_treesitter#foldexpr()"

-- display
o.signcolumn = "yes"

-- o.modifiable = true
-- o.fileencoding = "utf-8"

opt.clipboard = "unnamedplus"

o.termguicolors = true

o.laststatus = 0

o.scrolloff = 7
o.sidescrolloff = 5

o.pumheight = 12

o.completeopt = "menu,menuone,noselect"

o.confirm = true

opt.fillchars = {
  eob = " ",
  fold = " ",
  msgsep = " ",
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
o.directory = settings.swapdir

o.undofile = true
o.undodir = settings.undodir

o.backup = true
o.backupdir = mo.settings.backupdir

-- Message output on vim actions
opt.shortmess:append({ W = true, I = true, c = true, C = true })

-- fix markdown indentation settings
vim.g.markdown_recommended_style = 0
