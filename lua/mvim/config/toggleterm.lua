local M = {}

function M.setup()
  require("toggleterm").setup({
    open_mapping = [[<c-\>]],
    hide_numbers = true,
    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = 1,
    start_in_insert = true,
    insert_mappings = false,
    terminal_mappings = true,
    persist_size = false,
    direction = "horizontal",
    close_on_exit = true,
    size = function(term)
      if term.direction == "horizontal" then
        return 15
      elseif term.direction == "vertical" then
        return math.floor(vim.o.columns * 0.4)
      end
    end,
    float_opts = {
      border = "rounded",
      width = function()
        return math.floor(vim.o.columns * 0.9)
      end,
      height = function()
        return math.floor(vim.o.lines * 0.9)
      end,
      winblend = 0,
    },
  })

  local float_handler = function(term)
    if vim.fn.mapcheck("jk", "t") ~= "" then
      vim.api.nvim_buf_del_keymap(term.bufnr, "t", "jk")
      vim.api.nvim_buf_del_keymap(term.bufnr, "t", "<esc>")
    end
  end

  local Terminal = require("toggleterm.terminal").Terminal

  local lazygit = Terminal:new({
    cmd = "lazygit",
    dir = "git_dir",
    hidden = true,
    direction = "float",
    on_open = float_handler,
  })

  vim.keymap.set("n", "<leader>g", function()
    lazygit:toggle()
  end, { silent = true })
end

return M
