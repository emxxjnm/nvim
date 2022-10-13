local keymap = vim.keymap
local cmd = vim.cmd

-- editing
keymap.set("n", "<leader>w", cmd.write, {
  silent = true,
  desc = "Write the buffer to the current file",
})

-- editing
keymap.set("n", "<leader>q", cmd.quit, {
  silent = true,
  desc = "Quit the current window",
})

-- editing
-- vim.keymap.set("n", "<leader>WQ", ":wa<CR>:q<CR>", {
keymap.set("n", "<leader>WQ", function()
  cmd.wall()
  cmd.quit()
end, {
  silent = true,
  desc = "Write all changed buffers and Quit the window",
})

-- editing
keymap.set("n", "<leader>Q", function()
  cmd.qall({ bang = true })
end, {
  silent = true,
  desc = "Exit Vim(Any changes to buffers are lost)",
})

keymap.set("n", "<leader>p", '"+p', {
  silent = true,
  desc = "Copy text to the system clipboard",
})

-- motion
keymap.set("n", "<leader>;", "%", {
  silent = true,
  desc = "Find and jump to match item",
})

-- motion
keymap.set({ "n", "v" }, "H", "^", {
  silent = true,
  desc = "To the first non-blank character of the line",
})
keymap.set({ "n", "v" }, "L", "$", {
  silent = true,
  desc = "To the end of hte line",
})

keymap.set("n", "[<space>", [[<Cmd>put! =repeat(nr2char(10), v:count1)<CR>]], {
  silent = true,
  desc = "Add empty line above",
})
keymap.set("n", "]<space>", [[<Cmd>put =repeat(nr2char(10), v:count1)<CR>]], {
  silent = true,
  desc = "Add empty line below",
})

-- cahnge
keymap.set("n", "<leader>U", "gUiw`]", {
  silent = true,
  desc = "make word text uppercase",
})
keymap.set("i", "<C-u>", "_<Esc>mzwbgUiw`zi<Del>", {
  silent = true,
  desc = "mark word text uppercase",
})

keymap.set("n", "<M-Up>", "<cmd>move .-2<CR>==", {
  silent = true,
  desc = "Move current line up",
})
keymap.set("n", "<M-Down>", "<cmd>move .+1<CR>==", {
  silent = true,
  desc = "Move current line down",
})

keymap.set("n", "<leader>sh", ":set splitright<CR>:vsplit<CR>", {
  silent = true,
  desc = "Split left",
})
keymap.set("n", "<leader>sl", ":set nosplitright<CR>:vsplit<CR>:set splitright<CR>", {
  silent = true,
  desc = "Split right",
})
keymap.set("n", "<leader>sk", ":set splitbelow<CR>:split<CR>", {
  silent = true,
  desc = "Split above",
})
keymap.set("n", "<leader>sj", ":set nosplitbelow<CR>:split<CR>:set splitbelow<CR>", {
  silent = true,
  desc = "Split below",
})

-- resize the window
keymap.set("n", "<Up>", ":res -2<CR>", {
  silent = true,
  desc = "resize current window",
})
keymap.set("n", "<Down>", ":res +2<CR>", {
  silent = true,
  desc = "resize current window",
})
keymap.set("n", "<Left>", ":vertical resize -2<CR>", {
  silent = true,
  desc = "resize current window",
})
keymap.set("n", "<Right>", ":vertical resize +2<CR>", {
  silent = true,
  desc = "resize current window",
})

-- windows
keymap.set("n", "<leader>d", function()
  -- FIXME: vim will exit when explorer is opened
  cmd.bdelete({ bang = true })
end, {
  silent = true,
  desc = "Unload and delete current buffer",
})
keymap.set("n", "<leader>D", ":%bdelete|edit#|bdelete#<CR>", {
  silent = true,
  desc = "Unload and delete other buffers",
})

keymap.set("n", "<leader>gg", require("mvim.external").lazygit, {
  silent = true,
  desc = "Lazygit",
})

keymap.set("n", "j", [[(v:count > 1 ? 'm`' . v:count : '') . 'gj']], {
  expr = true,
  silent = true,
  desc = "Store relative line number jumps",
})
keymap.set("n", "k", [[(v:count > 1 ? 'm`' . v:count : '') . 'gk']], {
  expr = true,
  silent = true,
  desc = "Store relative line number jumps",
})

-- ==Quotes
keymap.set("n", [[<leader>"]], [[ciw"<C-r>""<Esc>]], {
  silent = true,
  desc = "wrap with double quotes",
})
keymap.set("n", [[<leader>']], [[ciw'<C-r>"'<Esc>]], {
  silent = true,
  desc = "wrap with single quotes",
})
keymap.set("n", [[<leader>`]], [[ciw`<C-r>"`<Esc>]], {
  silent = true,
  desc = "wrap with back ticks",
})
keymap.set("n", [[<leader>)]], [[ciw(<C-r>")<Esc>]], {
  silent = true,
  desc = "wrap with parens",
})
keymap.set("n", [[<leader>}]], [[ciw{<C-r>"}<Esc>]], {
  silent = true,
  desc = "wrap with braces",
})

-- ============ Insert ===========
keymap.set("i", "jj", [[col('.') == 1 ? '<Esc>' : '<Esc>l']], {
  expr = true,
  remap = true,
  desc = "Escape and move to the right preserve the cursor position",
})

keymap.set("i", "<M-Up>", "<Esc><Cmd>move .-2<CR>==gi", {
  silent = true,
  desc = "Move current line down",
})
keymap.set("i", "<M-Down>", "<Esc><Cmd>move .+1<CR>==gi", {
  silent = true,
  desc = "Move current line up",
})

-- ============ Visual ===========
keymap.set("v", "<leader>y", '"+y', {
  silent = true,
  desc = "Paste system clipboard text",
})

keymap.set("v", ">", ">gv", {
  silent = true,
  desc = "Visual shifting(does not exit visual mode)",
})
keymap.set("v", "<", "<gv", {
  silent = true,
  desc = "Visual shifting(does not exit visual mode)",
})

-- ============ Visual block ===========
keymap.set("x", "<M-Up>", ":move '<-2<CR>gv-gv", {
  silent = true,
  desc = "Move current line/block up",
})
keymap.set("x", "<M-Down>", ":move '>+1<CR>gv-gv", {
  silent = true,
  desc = "Move current line/block down",
})
