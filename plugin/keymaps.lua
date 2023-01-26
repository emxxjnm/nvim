local cmd = vim.cmd

local function keymap(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

-- editing
keymap("n", "<leader>w", function()
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
end, { desc = "Write the buffer to the current file" })

-- editing
keymap("n", "<leader>q", cmd.quit, { desc = "Quit the current window" })

-- editing
keymap("n", "<leader>WQ", ":wa<CR>:q<CR>", { desc = "Write all buffers and Quit" })

-- editing
keymap("n", "<leader>Q", function()
  cmd.qall({ bang = true })
end, {
  desc = "Exit Vim(Any changes to buffers are lost)",
})

keymap("n", "<leader>p", '"+p', { desc = "Copy text to the system clipboard" })

-- motion
keymap("n", "<leader>;", "%", { desc = "Find and jump to match item" })

-- motion
keymap({ "n", "v" }, "H", "^", { desc = "To the first non-blank character of the line" })
keymap({ "n", "v" }, "L", "$", { desc = "To the end of hte line" })

keymap("n", "[<space>", [[<Cmd>put! =repeat(nr2char(10), v:count1)<CR>]], {
  desc = "Add empty line above",
})
keymap("n", "]<space>", [[<Cmd>put =repeat(nr2char(10), v:count1)<CR>]], {
  desc = "Add empty line below",
})

-- change
keymap("n", "<leader>U", "gUiw`]", { desc = "make word text uppercase" })
keymap("i", "<C-u>", "_<Esc>mzwbgUiw`zi<Del>", { desc = "mark word text uppercase" })

-- move line
keymap("n", "<M-Up>", "<cmd>move .-2<CR>==", { desc = "Move current line up" })
keymap("n", "<M-Down>", "<cmd>move .+1<CR>==", { desc = "Move current line down" })

-- split window
keymap("n", "<leader>-", "<C-W>s", { desc = "Split window below" })
keymap("n", "<leader>|", "<C-W>v", { desc = "Split window right" })

-- resize window
keymap("n", "<Up>", "<Cmd>resize +2<CR>", { desc = "resize current window" })
keymap("n", "<Down>", "<Cmd>resize -2<CR>", { desc = "resize current window" })
keymap("n", "<Left>", "<Cmd>vertical resize -2<CR>", { desc = "resize current window" })
keymap("n", "<Right>", "<Cmd>vertical resize +2<CR>", { desc = "resize current window" })

-- windows
keymap("n", "<leader>d", function()
  -- FIXME: vim will exit when explorer is opened
  cmd.bdelete({ bang = true })
end, {
  desc = "Unload and delete current buffer",
})
keymap("n", "<leader>D", ":%bdelete|edit#|bdelete#<CR>", {
  desc = "Unload and delete other buffers",
})

keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", {
  expr = true,
  desc = "Store relative line number jumps",
})
keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", {
  expr = true,
  desc = "Store relative line number jumps",
})

-- ==Quotes
keymap("n", [[<leader>"]], [[ciw"<C-r>""<Esc>]], {
  desc = "wrap with double quotes",
})
keymap("n", [[<leader>']], [[ciw'<C-r>"'<Esc>]], {
  desc = "wrap with single quotes",
})
keymap("n", [[<leader>`]], [[ciw`<C-r>"`<Esc>]], {
  desc = "wrap with back ticks",
})
keymap("n", [[<leader>)]], [[ciw(<C-r>")<Esc>]], {
  desc = "wrap with parens",
})
keymap("n", [[<leader>}]], [[ciw{<C-r>"}<Esc>]], {
  desc = "wrap with braces",
})

keymap({ "i", "n" }, "<esc>", "<cmd>nohlsearch<cr><esc>", {
  desc = "Escape and clear hlsearch",
})

-- ============ Insert ===========
keymap("i", "jj", [[col('.') == 1 ? '<Esc>' : '<Esc>l']], {
  expr = true,
  remap = true,
  desc = "Escape and move to the right preserve the cursor position",
})

-- move line
keymap("i", "<M-Up>", "<Esc><Cmd>move .-2<CR>==gi", { desc = "Move current line down" })
keymap("i", "<M-Down>", "<Esc><Cmd>move .+1<CR>==gi", { desc = "Move current line up" })

-- ============ Visual ===========
keymap("v", "<leader>y", '"+y', {
  desc = "Paste system clipboard text",
})

keymap("v", ">", ">gv", {
  desc = "Visual shifting(does not exit visual mode)",
})
keymap("v", "<", "<gv", {
  desc = "Visual shifting(does not exit visual mode)",
})

-- ============ Visual block ===========
keymap("x", "<M-Up>", ":move '<-2<CR>gv-gv", {
  desc = "Move current line/block up",
})
keymap("x", "<M-Down>", ":move '>+1<CR>gv-gv", {
  desc = "Move current line/block down",
})
