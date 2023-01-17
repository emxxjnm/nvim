local cmd = vim.cmd
local keymap = vim.keymap

-- editing
keymap.set("n", "<leader>w", function()
  local buf_name = vim.api.nvim_buf_get_name(0)
  if buf_name == nil or buf_name == "" then
    local root = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    vim.ui.input({ prompt = "Input filename, current workspace: " .. root }, function(input)
      if input ~= nil then
        cmd.write(input)
      end
    end)
  else
    cmd.write()
  end
end, {
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

-- change
keymap.set("n", "<leader>U", "gUiw`]", { desc = "make word text uppercase" })
keymap.set("i", "<C-u>", "_<Esc>mzwbgUiw`zi<Del>", { desc = "mark word text uppercase" })

-- move line
keymap.set("n", "<M-Up>", "<cmd>move .-2<CR>==", { desc = "Move current line up" })
keymap.set("n", "<M-Down>", "<cmd>move .+1<CR>==", { desc = "Move current line down" })

-- split window
keymap.set("n", "<leader>-", "<C-W>s", { desc = "Split window below" })
keymap.set("n", "<leader>|", "<C-W>v", { desc = "Split window right" })

-- resize window
keymap.set("n", "<Up>", "<Cmd>resize +2<CR>", { desc = "resize current window" })
keymap.set("n", "<Down>", "<Cmd>resize -2<CR>", { desc = "resize current window" })
keymap.set("n", "<Left>", "<Cmd>vertical resize -2<CR>", { desc = "resize current window" })
keymap.set("n", "<Right>", "<Cmd>vertical resize +2<CR>", { desc = "resize current window" })

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

keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", {
  expr = true,
  silent = true,
  desc = "Store relative line number jumps",
})
keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", {
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

keymap.set({ "i", "n" }, "<esc>", "<cmd>nohlsearch<cr><esc>", {
  desc = "Escape and clear hlsearch",
})

-- ============ Insert ===========
keymap.set("i", "jj", [[col('.') == 1 ? '<Esc>' : '<Esc>l']], {
  expr = true,
  remap = true,
  desc = "Escape and move to the right preserve the cursor position",
})

-- move line
keymap.set("i", "<M-Up>", "<Esc><Cmd>move .-2<CR>==gi", { desc = "Move current line down" })
keymap.set("i", "<M-Down>", "<Esc><Cmd>move .+1<CR>==gi", { desc = "Move current line up" })

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
