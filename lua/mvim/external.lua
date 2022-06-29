local M = {}

local Terminal = require("toggleterm.terminal").Terminal

local function float_handler(term)
  if vim.fn.mapcheck("jj", "t") ~= "" then
    vim.api.nvim_buf_del_keymap(term.bufnr, "t", "jj")
    vim.api.nvim_buf_del_keymap(term.bufnr, "t", "<Esc>")
  end
end

function M.lazygit()
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

return M
