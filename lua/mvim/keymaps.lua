local opts = { noremap = true, silent = true }

-- shorten function name
local keymap = vim.api.nvim_set_keymap

-- ============ Normal ===========
keymap("n", "<leader>w", ":w<cr>", opts)
keymap("n", "<leader>q", ":q<cr>", opts)
keymap("n", "<leader>WQ", ":wa<cr>:q<cr>", opts)
keymap("n", "<leader>Q", ":qa!<cr>", opts)

keymap("n", "<leader>p", '"+p', opts)

keymap("n", "<leader>c", "%", opts)

keymap("n", "<leader>o", "za", opts)

-- Move text up and down
-- keymap("n", "<a-k>", "<Esc>:m .-2<CR>==g", opts)
-- keymap("n", "<a-j>", "<Esc>:m .+1<CR>==g", opts)

keymap("n", "s", "<nop>", opts)
-- split the screens to up (horizontal), down (horizontal), left (vertical), right (vertical)
-- noremap sh :set nosplitright<CR>:vsplit<CR>:set splitright<CR>
-- noremap sj :set splitbelow<CR>:split<CR>
-- noremap sk :set nosplitbelow<CR>:split<CR>:set splitbelow<CR>
--- noremap sl :set splitright<CR>:vsplit<CR>

-- keymap("n", ",", ":WhichKey , n<cr>", opts)

-- Hop
keymap("n", "<leader>k", ":HopWord<cr>", opts)
keymap("n", "<leader>j", ":HopLine<cr>", opts)
keymap("n", "<leader>l", ":HopChar1<cr>", opts)
keymap("n", "<leader>h", ":HopChar2<cr>", opts)

-- nvim-tree
keymap("n", "<leader>E", ":NvimTreeToggle<cr>", opts)
keymap("n", "<leader>e", ":NvimTreeFindFileToggle<cr>", opts)

-- bufferline
keymap("n", "E", ":BufferLineCyclePrev<cr>", opts)
keymap("n", "R", ":BufferLineCycleNext<cr>", opts)

-- delete current buffer
keymap("n", "<leader>d", ":bdelete!<cr>", opts)

keymap("n", "H", "^", opts)
keymap("n", "L", "$", opts)

keymap("n", "n", "nzzzv", opts)
keymap("n", "N", "Nzzv", opts)

-- Telescope
keymap("n", "<leader>ff", ":Telescope find_files<cr>", opts)
keymap("n", "<leader>fg", ":Telescope live_grep_raw<cr>", opts)
keymap("n", "<leader>fr", ":Telescope frecency<cr>", opts)
keymap("n", "<leader>fp", ":Telescope projects<cr>", opts)
keymap("n", "<leader>fb", ":Telescope buffers<cr>", opts)
keymap("n", "<leader>fc", ":Telescope current_buffer_fuzzy_find<cr>", opts)

-- Toggleterm
keymap("n", "<C-\\>", ":ToggleTerm<cr>", opts)

-- dap
keymap("n", "<leader>b", "<cmd>lua require('dap').toggle_breakpoint()<cr>", opts)
keymap("n", "<leader>B", "<cmd>lua require('dap').toggle_breakpoint_condition()<cr>", opts)
keymap("n", "<F5>", "<cmd>lua require('dap').continue()<cr>", opts)
keymap("n", "<F6>", "<cmd>lua require('dapui').toggle()<cr>", opts)
keymap("n", "<F10>", "<cmd>lua require('dap').step_over()<cr>", opts)
keymap("n", "<F11>", "<cmd>lua require('dap').step_into()<cr>", opts)
keymap("n", "<F12>", "<cmd>lua require('dap').step_out()<cr>", opts)

-- vim-table-mode
-- keymap("n", "<leader>T", ":TableModeToggle<cr>", opts)

-- resize the window
keymap("n", "<up>", ":res -2<cr>", opts)
keymap("n", "<down>", ":res +2<cr>", opts)
keymap("n", "<left>", ":vertical resize -2<cr>", opts)
keymap("n", "<right>", ":vertical resize +2<cr>", opts)

-- ============ Insert ===========
keymap("i", "jj", "<ESC>", opts)

-- ============ Visual ===========
keymap("v", "<leader>y", '"+y', opts)

keymap("v", "H", "^", opts)
keymap("v", "L", "$", opts)
