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
      ["%"] = "matchup: Move to prev",
      c = "textobjects: Move to prev class",
      f = "textobjects: Move to prev function",
    },
    ["]"] = {
      ["%"] = "matchup: Move to next",
      c = "testojbects: Move to next class",
      f = "testojbects: Move to next function",
    },
  })
end

return M
