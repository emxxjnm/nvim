local fn = vim.fn
local o, wo, bo = vim.o, vim.wo, vim.bo

local buffer = { o, bo }
local window = { o, wo }
local global = { o }

local function opt(option, value, scopes)
  scopes = scopes or global
  for _, s in ipairs(scopes) do
    s[option] = value
  end
end

opt("textwidth", 80, buffer)
opt("incsearch", true)
opt("smartcase", true)
opt("ignorecase", true)
opt("number", true, window)
opt("relativenumber", true, window)
opt("ruler", true)
opt("cursorline", true, window)
-- opt("cursorcolumn", true, window)
opt("colorcolumn", "80,100", window)

opt("wrap", false, window)

opt("formatoptions", "1jcroql", buffer)
opt("encoding", "utf-8")
opt("laststatus", 2)

opt("foldlevel", 99, window)
opt("foldmethod", "expr", window)
opt("foldexpr", "nvim_treesitter#foldexpr()", window)

opt("showcmd", false)
opt("showmode", false)
opt("showmatch", false)

opt("autochdir", true)

opt("expandtab", true, buffer)
opt("tabstop", 2, buffer)
opt("softtabstop", 2, buffer)
opt("shiftwidth", 2, buffer)
-- opt("smarttab", true)

opt("exrc", true)
opt("secure", true)

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

opt("tw", 0, buffer)

opt("backspace", "indent,eol,start")

opt("splitright", true)
opt("splitbelow", true)
opt("inccommand", "nosplit")

-- opt("completeopt", "longest,noinsert,menuone,noselect,preview")
opt("completeopt", "menuone,noselect")

opt("lazyredraw", true)

opt("visualbell", true)

opt("signcolumn", "yes:1", window)

opt("swapfile", true)
opt("directory", fn.stdpath("cache") .. "/swap")

opt("backup", true)
opt("backupdir", fn.stdpath("cache") .. "/backup")
opt("writebackup", false)
opt("backupskip", "/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*,.vault.vim")

opt("undofile", true, buffer)
opt("undodir", fn.stdpath("cache") .. "/undo")

-- opt("spellfile", const.spell_path, "en.utf-8.add")

-- opt("mouse", "nivh")

opt("termguicolors", true)
opt("background", "dark")

opt("diffopt", "vertical,filler,internal,context:4")

opt("pumheight", 10)

opt("shortmess", o.shortmess .. "c")
