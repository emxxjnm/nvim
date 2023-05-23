local M = {
  "akinsho/toggleterm.nvim",
  keys = {
    { [[<C-\>]], desc = "Toggle terminal" },
    { "<leader>t=", "<Cmd>ToggleTerm direction=float<CR>", desc = "Float terminal" },
    { "<leader>t-", "<Cmd>ToggleTerm direction=horizontal<CR>", desc = "Horizontal terminal" },
    { "<leader>t|", "<Cmd>ToggleTerm direction=vertical<CR>", desc = "Vertical terminal" },
    {
      "<leader>gg",
      function()
        local T = require("toggleterm.terminal").Terminal
        T:new({
          cmd = "lazygit",
          dir = "git_dir",
          hidden = true,
          direction = "float",
          on_open = function(term)
            if vim.fn.mapcheck("jj", "t") ~= "" then
              vim.api.nvim_buf_del_keymap(term.bufnr, "t", "jj")
              vim.api.nvim_buf_del_keymap(term.bufnr, "t", "<Esc>")
            end
          end,
        }):toggle()
      end,
      desc = "Lazygit",
    },
  },
  opts = {
    open_mapping = [[<c-\>]],
    shade_terminals = false,
    shading_factor = 1,
    start_in_insert = true,
    insert_mappings = false,
    persist_size = false,
    direction = "horizontal",
    autochdir = true,
    highlights = {
      NormalFloat = { link = "NormalFloat" },
      FloatBorder = { link = "FloatBorder" },
    },
    size = function(term)
      if term.direction == "horizontal" then
        return math.floor(vim.o.lines * 0.4)
      elseif term.direction == "vertical" then
        return math.floor(vim.o.columns * 0.4)
      end
    end,
    float_opts = {
      border = mo.styles.border,
      width = function()
        return math.floor(vim.o.columns * 0.9)
      end,
      height = function()
        return math.floor(vim.o.lines * 0.9)
      end,
    },
  },
  init = function()
    require("mvim.utils").augroup("TerminalMappings", {
      event = { "TermOpen" },
      pattern = "term://*toggleterm#*",
      command = function(args)
        local opts = { buffer = args.buf, silent = true }
        vim.keymap.set("t", "jj", [[<C-\><C-n>]], opts)
        vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], opts)
        vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], opts)
        vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], opts)
        vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], opts)
        vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], opts)
        vim.keymap.set("t", "<leader><Tab>", "<Cmd>close \\| :bnext<CR>", opts)
      end,
      desc = "Setup toggleterm keymap",
    })
  end,
}

return M
