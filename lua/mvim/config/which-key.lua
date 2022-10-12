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
      border = mo.style.border.current,
      winblend = 0,
    },
    layout = {
      spacing = 5,
      align = "center",
    },
    show_help = false,
  })

  wk.register({
    ["<leader>"] = {
      f = { name = "+telescope" },
      g = { name = "+git" },
      s = { name = "+split" },
    },
    ["["] = {
      ["%"] = "matchup: Go to prev",
      c = "textobjects: Go to prev class",
      f = "textobjects: Go to prev function",
    },
    ["]"] = {
      ["%"] = "matchup: Go to next",
      c = "testojbects: Go to next class",
      f = "testojbects: Go to next function",
    },
  })
end

return M
