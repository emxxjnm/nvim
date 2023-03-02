local function keymap(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

-- editing: save
keymap("n", "<leader>w", "<Cmd>w<CR>", { desc = "Save file" })
keymap("n", "<leader>W", "<Cmd>wa<CR>", { desc = "Save files" })

-- editing: quit
keymap("n", "<leader>q", "<Cmd>q<CR>", { desc = "Quit" })
keymap("n", "<leader>Q", "<Cmd>q!<CR>", { desc = "Force quit" })

-- copy/paste
keymap("n", "<leader>p", '"+p', { desc = "Paste clipboard text" })
keymap("v", "<leader>y", '"+y', { desc = "Copy to clipboard" })

-- motion
keymap("n", "<leader>;", "%", { desc = "Jump to match item" })

-- motion
keymap({ "n", "v" }, "H", "^", { desc = "To the first non-blank char of the line" })
keymap({ "n", "v" }, "L", "$", { desc = "To the end of the line" })

-- change
keymap("n", "<leader>u", "gUiw", { desc = "Uppercase" })
keymap("i", "<C-u>", "_<Esc>mzwbgUiw`zi<Del>", { desc = "Uppercase" })

-- move line
keymap("n", "<M-k>", "<Cmd>move .-2<CR>==", { desc = "Move up" })
keymap("n", "<M-j>", "<Cmd>move .+1<CR>==", { desc = "Move down" })
keymap("i", "<M-k>", "<Esc><Cmd>move .-2<CR>==gi", { desc = "Move up" })
keymap("i", "<M-j>", "<Esc><Cmd>move .+1<CR>==gi", { desc = "Move down" })
keymap("v", "<M-k>", ":move '<-2<cr>gv=gv", { desc = "Move up" })
keymap("v", "<M-j>", ":move '>+1<cr>gv=gv", { desc = "Move down" })

-- split window
keymap("n", "<leader>-", "<C-W>s", { desc = "Split below" })
keymap("n", "<leader>|", "<C-W>v", { desc = "Split right" })

-- Move to window
keymap("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- resize window
keymap("n", "<Up>", "<Cmd>resize +2<CR>", { desc = "Increase window height" })
keymap("n", "<Down>", "<Cmd>resize -2<CR>", { desc = "Decrease window height" })
keymap("n", "<Left>", "<Cmd>vertical resize -2<CR>", { desc = "Increase window width" })
keymap("n", "<Right>", "<Cmd>vertical resize +2<CR>", { desc = "Decrease window width" })

-- Saner behavior of n and N
keymap("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
keymap("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
keymap("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
keymap("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
keymap("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
keymap("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

keymap("v", ">", ">gv", { desc = "Visual shifting" })
keymap("v", "<", "<gv", { desc = "Visual shifting" })

-- Clear search with <esc>
keymap({ "i", "n" }, "<esc>", "<Cmd>nohlsearch<CR><Esc>", { desc = "Escape and clear hlsearch" })

-- better up/down
keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

keymap("i", "jj", [[col('.') == 1 ? '<Esc>' : '<Esc>l']], { expr = true })

-- windows
-- FIXME: vim will exit when explorer is opened
keymap("n", "<leader>bd", "<Cmd>bdelete!<CR>", { desc = "Delete current" })
keymap("n", "<leader>bD", "<Cmd>%bdelete<Bar>edit#<Bar>bdelete#<CR>", { desc = "Delete others" })
