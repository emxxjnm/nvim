local keymap = vim.keymap.set

mo.augroup("PlaceLastLoc", {
  {
    event = "BufReadPost",
    pattern = "*",
    command = function()
      if vim.bo.ft ~= "gitcommit" and vim.fn.win_gettype() ~= "popup" then
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local line_nr = mark[1]
        local line_count = vim.api.nvim_buf_line_count(0)

        if line_nr > 0 and line_nr <= line_count then
          vim.api.nvim_win_set_cursor(0, mark)
        end
      end
    end,
    desc = "Go to last loc when opening a buffer",
  },
})

mo.augroup("SmartClose", {
  {
    event = "FileType",
    pattern = { "qf", "help", "man", "lspinfo", "startuptime", "spectre_panel" },
    command = function(event)
      vim.bo[event.buf].buflisted = false
      keymap("n", "q", "<Cmd>close<CR>", { noremap = true, silent = true })
    end,
    desc = "Close certain filetypes by pressing <q>",
  },
})

mo.augroup("EslintFormat", {
  {
    event = "BufWritePre",
    pattern = { "*.ts", "*.tsx", "*.js", "*.jsx", "*.vue" },
    command = "EslintFixAll",
    desc = "Auto exec eslint fix on save",
  },
})

mo.augroup("SetupTerminalMappings", {
  {
    event = { "TermOpen" },
    pattern = "term://*",
    command = function()
      if vim.bo.filetype == "toggleterm" then
        local opts = { buffer = 0, silent = true }
        keymap("t", "jj", [[<C-\><C-n>]], opts)
        keymap("t", "<Esc>", [[<C-\><C-n>]], opts)
        keymap("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
        keymap("t", "<C-h>", [[<C-\><C-n><C-w>h]], opts)
        keymap("t", "<C-j>", [[<C-\><C-n><C-w>j]], opts)
        keymap("t", "<C-k>", [[<C-\><C-n><C-w>k]], opts)
        keymap("t", "<C-l>", [[<C-\><C-n><C-w>l]], opts)
        keymap("t", "<leader><Tab>", "<Cmd>close \\| :bnext<CR>", opts)

        keymap("n", "<C-h>", [[<C-\><C-n><C-w>hi]], opts)
        keymap("n", "<C-j>", [[<C-\><C-n><C-w>ji]], opts)
        keymap("n", "<C-k>", [[<C-\><C-n><C-w>ki]], opts)
        keymap("n", "<C-l>", [[<C-\><C-n><C-w>li]], opts)
      end
    end,
    desc = "Setup toggleterm keymap",
  },
})
