local keymap = vim.keymap.set
local augroup = require("mvim.utils").augroup

augroup("PlaceLastLoc", {
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

augroup("SmartClose", {
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

augroup("AutoCursorLine", {
  {
    event = { "InsertLeave", "WinEnter" },
    command = function()
      local ok, cl = pcall(vim.api.nvim_win_get_var, 0, "auto-cursorline")
      if ok and cl then
        vim.wo.cursorline = true
        vim.api.nvim_win_del_var(0, "auto-cursorline")
      end
    end,
    desc = "Hide cursor line in inactive window",
  },
  {
    event = { "InsertEnter", "WinLeave" },
    command = function()
      local cl = vim.wo.cursorline
      if cl then
        vim.api.nvim_win_set_var(0, "auto-cursorline", cl)
        vim.wo.cursorline = false
      end
    end,
    desc = "Show cursor line only in active window",
  },
})

augroup("EslintFormat", {
  {
    event = "BufWritePre",
    pattern = { "*.ts", "*.tsx", "*.js", "*.jsx", "*.vue" },
    command = "EslintFixAll",
    desc = "Auto exec eslint fix on save",
  },
})

augroup("SetupTerminalMappings", {
  {
    event = { "TermOpen" },
    pattern = "term://*toggleterm#*",
    command = function()
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
    end,
    desc = "Setup toggleterm keymap",
  },
})
