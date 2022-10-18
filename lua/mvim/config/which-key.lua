local M = {}

function M.setup()
  local wk = require("which-key")
  local icons = mo.style.icons

  wk.setup({
    plugins = {
      presets = {
        operators = false,
        motions = false,
        text_objects = false,
        windows = false,
        nav = false,
        z = true,
        g = false,
      },
    },
    icons = {
      breadcrumb = icons.misc.double_right,
      separator = icons.misc.gg .. " ",
      group = icons.misc.add,
    },
    window = {
      border = mo.style.border.current,
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
    },
    ["]"] = {
      ["%"] = "matchup: Move to next",
    },
  })
end

return M
