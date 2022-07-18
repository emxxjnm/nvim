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

opt("incsearch", true)
opt("smartcase", true)
opt("ignorecase", true)

opt("number", true, window)
opt("relativenumber", true, window)

opt("ruler", false)
opt("cursorline", true, window)
-- opt("cursorcolumn", true, window)
-- opt("colorcolumn", "80,100", window)

-- opt("textwidth", 0, buffer)
opt("wrap", false, window)

opt("formatoptions", "1jcroql", buffer)
opt("encoding", "utf-8")

opt("laststatus", 3)

opt("foldlevel", 99, window)
opt("foldmethod", "expr", window)
opt("foldexpr", "nvim_treesitter#foldexpr()", window)

-- opt("showcmd", false)
opt("showmode", false)
-- opt("showmatch", false)

-- opt("autochdir", true)

-- Don't mess with 'tabstop', with 'expandtab' it isn't used.
-- Instead set softtabstop=-1, then 'shiftwidth' is used.
opt("expandtab", true, buffer)
opt("softtabstop", -1, buffer)
opt("shiftwidth", 2, buffer)
-- opt("tabstop", 2, buffer)

-- opt("exrc", false)
-- opt("secure", false)

opt("smartindent", true, buffer)

opt("list", true, window)
opt("listchars", "tab:»·,nbsp:+,trail:⎵,extends:→,precedes:←", window)

-- opt("conceallevel", 2, window)
-- opt("concealcursor", "nc", window)

-- opt("syntax", "off")

opt("scrolloff", 8)

opt("timeout", false)
opt("ttimeoutlen", 10)
opt("timeoutlen", 500)
opt("updatetime", 500)

opt("viewoptions", "cursor,folds,curdir,slash,unix")

opt("backspace", "indent,eol,start")

opt("splitright", true)
opt("splitbelow", true)

-- opt("completeopt", "longest,noinsert,menuone,noselect,preview")
opt("completeopt", "menu,menuone,noselect")

opt("lazyredraw", true)

opt("visualbell", true)

opt("signcolumn", "yes", window)

opt("swapfile", true)
opt("directory", swap_dir)

opt("backup", true)
opt("writebackup", false)
opt("backupdir", backup_dir)
opt("backupskip", "/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*,.vault.vim")

opt("undofile", true, buffer)
opt("undodir", undo_dir)

-- opt("spellfile", const.spell_path, "en.utf-8.add")

-- opt("mouse", "nivh")

opt("termguicolors", true)
opt("background", "dark")

opt("diffopt", "vertical,filler,internal,context:5")

opt("pumheight", 10)

opt("shortmess", o.shortmess .. "c")

opt("wildmenu", true)

-- nvim
opt("inccommand", "split")
