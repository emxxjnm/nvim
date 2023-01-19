local M = {
  "akinsho/toggleterm.nvim",
  event = "VeryLazy",
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
}

function M.init()
  local Terminal = require("toggleterm.terminal").Terminal
  local function float_handler(term)
    if vim.fn.mapcheck("jj", "t") ~= "" then
      vim.api.nvim_buf_del_keymap(term.bufnr, "t", "jj")
      vim.api.nvim_buf_del_keymap(term.bufnr, "t", "<Esc>")
    end
  end

  local function toggle_lazygit()
    Terminal
      :new({
        cmd = "lazygit",
        dir = "git_dir",
        hidden = true,
        direction = "float",
        on_open = float_handler,
      })
      :toggle()
  end

  vim.keymap.set("n", "<leader>gg", toggle_lazygit, {
    silent = true,
    desc = "Lazygit",
  })
end

return M
