local M = {}

function M.setup()
  local wk = require("which-key")
  wk.setup({
    plugins = {
      spelling = {
        enabled = true,
      },
    },
    window = {
      border = "none",
      winblend = 0,
    },
    layout = {
      spacing = 5,
      align = "center",
    },
  })
end

return M
