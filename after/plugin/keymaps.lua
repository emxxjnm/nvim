-- editing
vim.keymap.set("n", "<leader>w", vim.cmd.write, {
  silent = true,
  desc = "Write the buffer to the current file",
})

-- editing
vim.keymap.set("n", "<leader>q", vim.cmd.quit, {
  silent = true,
  desc = "Quit the current window",
})

-- editing
vim.keymap.set("n", "<leader>WQ", ":wa<CR>:q<CR>", {
  silent = true,
  desc = "Write all changed buffers and Quit the window",
})

-- editing
vim.keymap.set("n", "<leader>Q", ":qa!<CR>", {
  silent = true,
  desc = "Exit Vim(Any changes to buffers are lost)",
})

vim.keymap.set("n", "<leader>p", '"+p', {
  silent = true,
  desc = "Copy text to the system clipboard",
})

-- motion
vim.keymap.set("n", "<leader>;", "%", {
  silent = true,
  desc = "Find and jump to match item",
})

-- motion
vim.keymap.set({ "n", "v" }, "H", "^", {
  silent = true,
  desc = "To the first non-blank character of the line",
})
vim.keymap.set({ "n", "v" }, "L", "$", {
  silent = true,
  desc = "To the end of hte line",
})

vim.keymap.set("n", "[<space>", [[<Cmd>put! =repeat(nr2char(10), v:count1)<CR>]], {
  silent = true,
  desc = "Add empty line above",
})
vim.keymap.set("n", "]<space>", [[<Cmd>put =repeat(nr2char(10), v:count1)<CR>]], {
  silent = true,
  desc = "Add empty line below",
})

-- cahnge
vim.keymap.set("n", "<leader>U", "gUiw`]", {
  silent = true,
  desc = "make word text uppercase",
})
vim.keymap.set("i", "<C-u>", "_<Esc>mzwbgUiw`zi<Del>", {
  silent = true,
  desc = "mark word text uppercase",
})

vim.keymap.set("n", "<M-Up>", "<cmd>move-2<CR>==", {
  silent = true,
  desc = "Move current line up",
})
vim.keymap.set("n", "<M-Down>", "<cmd>move+<CR>==", {
  silent = true,
  desc = "Move current line down",
})

vim.keymap.set("n", "<leader>sh", ":set splitright<CR>:vsplit<CR>", {
  silent = true,
  desc = "Split left",
})
vim.keymap.set("n", "<leader>sl", ":set nosplitright<CR>:vsplit<CR>:set splitright<CR>", {
  silent = true,
  desc = "Split right",
})
vim.keymap.set("n", "<leader>sk", ":set splitbelow<CR>:split<CR>", {
  silent = true,
  desc = "Split above",
})
vim.keymap.set("n", "<leader>sj", ":set nosplitbelow<CR>:split<CR>:set splitbelow<CR>", {
  silent = true,
  desc = "Split below",
})

-- resize the window
vim.keymap.set("n", "<Up>", ":res -2<CR>", {
  silent = true,
  desc = "resize current window",
})
vim.keymap.set("n", "<Down>", ":res +2<CR>", {
  silent = true,
  desc = "resize current window",
})
vim.keymap.set("n", "<Left>", ":vertical resize -2<CR>", {
  silent = true,
  desc = "resize current window",
})
vim.keymap.set("n", "<Right>", ":vertical resize +2<CR>", {
  silent = true,
  desc = "resize current window",
})

-- window
vim.keymap.set("n", "<leader>d", ":bdelete!<CR>", {
  silent = true,
  desc = "Unload and delete current buffer",
})
vim.keymap.set("n", "<leader>D", ":%bdelete|edit#|bdelete#<CR>", {
  silent = true,
  desc = "Unload and delete other buffers",
})

vim.keymap.set("n", "<leader>gg", require("mvim.external").lazygit, {
  silent = true,
  desc = "Lazygit",
})

vim.keymap.set("n", "j", [[(v:count > 1 ? 'm`' . v:count : '') . 'gj']], {
  expr = true,
  silent = true,
  desc = "Store relative line number jumps",
})
vim.keymap.set("n", "k", [[(v:count > 1 ? 'm`' . v:count : '') . 'gk']], {
  expr = true,
  silent = true,
  desc = "Store relative line number jumps",
})

-- ==Quotes
vim.keymap.set("n", [[<leader>"]], [[ciw"<C-r>""<Esc>]], {
  silent = true,
  desc = "wrap with double quotes",
})
vim.keymap.set("n", [[<leader>']], [[ciw'<C-r>"'<Esc>]], {
  silent = true,
  desc = "wrap with single quotes",
})
vim.keymap.set("n", [[<leader>`]], [[ciw`<C-r>"`<Esc>]], {
  silent = true,
  desc = "wrap with back ticks",
})
vim.keymap.set("n", [[<leader>)]], [[ciw(<C-r>")<Esc>]], {
  silent = true,
  desc = "wrap with parens",
})
vim.keymap.set("n", [[<leader>}]], [[ciw{<C-r>"}<Esc>]], {
  silent = true,
  desc = "wrap with braces",
})

-- ============ Insert ===========
vim.keymap.set("i", "jj", [[col('.') == 1 ? '<Esc>' : '<Esc>l']], {
  expr = true,
  remap = true,
  desc = "Escape and move to the right preserve the cursor position",
})

-- ============ Visual ===========
vim.keymap.set("v", "<leader>y", '"+y', {
  silent = true,
  desc = "Paste system clipboard text",
})

vim.keymap.set("v", ">", ">gv", {
  silent = true,
  desc = "Visual shifting(does not exit visual mode)",
})
vim.keymap.set("v", "<", "<gv", {
  silent = true,
  desc = "Visual shifting(does not exit visual mode)",
})
