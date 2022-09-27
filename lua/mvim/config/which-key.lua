local M = {}

function M.setup()
  local wk = require("which-key")
  wk.setup({
    plugins = {
      spelling = {
        enabled = true,
      },
      presets = {
        operators = false,
        motions = false,
        text_objects = false,
        windows = false,
        nav = false,
        z = false,
        g = false,
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
    show_help = false,
  })
end

return M
