local stdpath = vim.fn.stdpath
local o, wo, bo = vim.o, vim.wo, vim.bo

local buffer = { o, bo }
local window = { o, wo }
local global = { o }

local undo_dir = stdpath("cache") .. "/undo"
local swap_dir = stdpath("cache") .. "/swap"
local backup_dir = stdpath("cache") .. "/backup"

local function opt(option, value, scopes)
  scopes = scopes or global
  for _, s in ipairs(scopes) do
    s[option] = value
  end
end

opt("expandtab", true, buffer)
opt("shiftwidth", 2, buffer)
opt("softtabstop", -1, buffer)
-- opt("tabstop", 2, buffer)
opt("smartindent", true, buffer)
opt("formatoptions", "1jcrql", buffer)

opt("number", true, window)
opt("relativenumber", true, window)
opt("cursorline", true, window)
opt("wrap", false, window)
opt("foldlevel", 99, window)
opt("foldmethod", "expr", window)
opt("foldexpr", "nvim_treesitter#foldexpr()", window)
opt("signcolumn", "yes", window)

opt("clipboard", "unnamedplus")
opt("incsearch", true)
opt("smartcase", true)
opt("ignorecase", true)
opt("encoding", "utf-8")
opt("laststatus", 3)
opt("showmode", false)
opt("scrolloff", 7)
opt("timeoutlen", 300)
opt("updatetime", 500)
opt("backspace", "indent,eol,start")
opt("splitright", true)
opt("splitbelow", true)
opt("completeopt", "menu,menuone,noselect")
opt("lazyredraw", true)
opt("swapfile", true)
opt("directory", swap_dir)
opt("backup", true)
opt("backupdir", backup_dir)
opt("undofile", true, buffer)
opt("undodir", undo_dir)
opt("termguicolors", true)
opt("background", "dark")
opt("shortmess", o.shortmess .. "c")
opt("wildmenu", true)
opt("inccommand", "split")
