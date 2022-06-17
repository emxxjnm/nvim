local opts = { noremap = true, silent = true }

-- shorten function name
local keymap = vim.api.nvim_set_keymap

-- ============ Normal ===========
keymap("n", "<leader>w", ":w<cr>", opts)
keymap("n", "<leader>q", ":q<cr>", opts)
keymap("n", "<leader>WQ", ":wa<cr>:q<cr>", opts)
keymap("n", "<leader>Q", ":qa!<cr>", opts)

keymap("n", "<leader>p", '"+p', opts)

keymap("n", "<leader>;", "%", opts)

-- keymap("n", "<leader>o", "za", opts)

keymap("n", "H", "^", opts)
keymap("n", "L", "$", opts)

keymap("n", "n", "nzzzv", opts)
keymap("n", "N", "Nzzv", opts)

-- Move text up and down
keymap("n", "<s-up>", "<esc>:m .-2<cr>==g<esc>", opts)
keymap("n", "<s-down>", "<esc>:m .+1<cr>==g<esc>", opts)

-- note: <c-w>o close all split windows except current
keymap("n", "<leader>sh", ":set splitright<cr>:vsplit<cr>", opts)
keymap("n", "<leader>sl", ":set nosplitright<cr>:vsplit<cr>:set splitright<cr>", opts)
keymap("n", "<leader>sk", ":set splitbelow<cr>:split<cr>", opts)
keymap("n", "<leader>sj", ":set nosplitbelow<cr>:split<cr>:set splitbelow<cr>", opts)

-- resize the window
keymap("n", "<up>", ":res -2<cr>", opts)
keymap("n", "<down>", ":res +2<cr>", opts)
keymap("n", "<left>", ":vertical resize -2<cr>", opts)
keymap("n", "<right>", ":vertical resize +2<cr>", opts)

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
keymap("n", "<leader>d", ":bdelete!<cr>", opts)
keymap("n", "<leader>D", ":%bdelete|edit#|bdelete#<cr>", opts)

-- Telescope
keymap("n", "<leader>ff", ":Telescope find_files<cr>", opts)
keymap("n", "<leader>fg", ":Telescope live_grep_args<cr>", opts)
keymap("n", "<leader>fr", ":Telescope frecency<cr>", opts)
keymap("n", "<leader>fp", ":Telescope projects<cr>", opts)
keymap("n", "<leader>fb", ":Telescope buffers<cr>", opts)
keymap("n", "<leader>fc", ":Telescope current_buffer_fuzzy_find<cr>", opts)

-- Toggleterm
keymap("n", "<c-\\>", ":ToggleTerm<cr>", opts)

-- dap
keymap("n", "<leader>b", "<cmd>lua require('dap').toggle_breakpoint()<cr>", opts)
keymap("n", "<F5>", "<cmd>lua require('dap').continue()<cr>", opts)
-- keymap("n", "<s-F5>", "<cmd>lua require('dap').disconnect()<cr>", opts)
-- keymap("n", "<F6>", "<cmd>lua require('dap').pause()<cr>", opts)
keymap("n", "<F10>", "<cmd>lua require('dap').step_over()<cr>", opts)
keymap("n", "<F11>", "<cmd>lua require('dap').step_into()<cr>", opts)
keymap("n", "<F12>", "<cmd>lua require('dap').step_out()<cr>", opts)

-- vim-table-mode
-- keymap("n", "<leader>T", ":TableModeToggle<cr>", opts)

-- ============ Insert ===========
keymap("i", "jj", "<esc>", opts)

-- ============ Visual ===========
keymap("v", "<leader>y", '"+y', opts)

keymap("v", "H", "^", opts)
keymap("v", "L", "$", opts)
