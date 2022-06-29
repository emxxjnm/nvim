local opts = { noremap = true, silent = true }

-- shorten function name
local keymap = vim.api.nvim_set_keymap

-- ============ Normal ===========
keymap("n", "<leader>w", ":w<CR>", opts)
keymap("n", "<leader>q", ":q<CR>", opts)
keymap("n", "<leader>WQ", ":wa<CR>:q<CR>", opts)
keymap("n", "<leader>Q", ":qa!<CR>", opts)

keymap("n", "<leader>p", '"+p', opts)

keymap("n", "<leader>;", "%", opts)

-- keymap("n", "<leader>o", "za", opts)

keymap("n", "H", "^", opts)
keymap("n", "L", "$", opts)

keymap("n", "n", "nzzzv", opts)
keymap("n", "N", "Nzzv", opts)

-- Move text up and down
keymap("n", "<M-Up>", "<Esc>:m .-2<cr>==g<Esc>", opts)
keymap("n", "<M-Down>", "<Esc>:m .+1<cr>==g<Esc>", opts)

-- note: <c-w>o close all split windows except current
keymap("n", "<leader>sh", ":set splitright<CR>:vsplit<CR>", opts)
keymap("n", "<leader>sl", ":set nosplitright<CR>:vsplit<CR>:set splitright<CR>", opts)
keymap("n", "<leader>sk", ":set splitbelow<CR>:split<CR>", opts)
keymap("n", "<leader>sj", ":set nosplitbelow<CR>:split<CR>:set splitbelow<CR>", opts)

-- resize the window
keymap("n", "<Up>", ":res -2<CR>", opts)
keymap("n", "<Down>", ":res +2<CR>", opts)
keymap("n", "<Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<Right>", ":vertical resize +2<CR>", opts)

-- Hop
keymap("n", "<leader>k", ":HopWord<CR>", opts)
keymap("n", "<leader>j", ":HopLine<CR>", opts)
keymap("n", "<leader>l", ":HopChar1<CR>", opts)
keymap("n", "<leader>h", ":HopChar2<CR>", opts)

-- nvim-tree
keymap("n", "<leader>E", ":NvimTreeToggle<CR>", opts)
keymap("n", "<leader>e", ":NvimTreeFindFileToggle<CR>", opts)

-- bufferline
keymap("n", "E", ":BufferLineCyclePrev<CR>", opts)
keymap("n", "R", ":BufferLineCycleNext<CR>", opts)
keymap("n", "<leader>d", ":bdelete!<CR>", opts)
keymap("n", "<leader>D", ":%bdelete|edit#|bdelete#<CR>", opts)

-- Telescope
keymap("n", "<leader>ff", ":Telescope find_files<CR>", opts)
keymap("n", "<leader>fg", ":Telescope live_grep_args<CR>", opts)
keymap("n", "<leader>fr", ":Telescope oldfiles<CR>", opts)
keymap("n", "<leader>fp", ":Telescope projects<CR>", opts)
keymap("n", "<leader>fb", ":Telescope buffers<CR>", opts)
keymap("n", "<leader>fc", ":Telescope current_buffer_fuzzy_find<CR>", opts)

-- Toggleterm
keymap("n", "<c-\\>", ":ToggleTerm<CR>", opts)
keymap("n", "<leader>g", ":lua require('mvim.external').lazygit()<CR>", opts)

-- dap
keymap("n", "<leader>b", ":lua require('dap').toggle_breakpoint()<CR>", opts)
keymap("n", "<F5>", ":lua require('dap').continue()<CR>", opts)
-- keymap("n", "<S-F5>", ":lua require('dap').disconnect()<CR>", opts)
-- keymap("n", "<F6>", ":lua require('dap').pause()<CR>", opts)
keymap("n", "<F10>", ":lua require('dap').step_over()<CR>", opts)
keymap("n", "<F11>", ":lua require('dap').step_into()<CR>", opts)
keymap("n", "<F12>", ":lua require('dap').step_out()<CR>", opts)

-- vim-table-mode
-- keymap("n", "<leader>T", ":TableModeToggle<CR>", opts)

-- ============ Insert ===========
keymap("i", "jj", "<Esc>", opts)

-- ============ Visual ===========
keymap("v", "<leader>y", '"+y', opts)

keymap("v", "H", "^", opts)
keymap("v", "L", "$", opts)
