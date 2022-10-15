local M = {}

local icons = mo.style.icons
local colors = require("catppuccin.palettes").get_palette()

function M.setup()
  require("todo-comments").setup({
    keywords = {
      FIX = {
        icon = icons.misc.tool,
        color = "fix",
        alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
      },
      TODO = { icon = icons.misc.tag, color = "todo" },
      HACK = { icon = icons.misc.flame, color = "hack" },
      WARN = { icon = icons.misc.bell, color = "warn", alt = { "WARNING", "XXX" } },
      PERF = {
        icon = icons.misc.rocket,
        color = "perf",
        alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" },
      },
      NOTE = { icon = icons.misc.comment, color = "note" },
      TEST = { icon = icons.misc.tower, color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
    },
    highlight = {
      before = "",
      keyword = "wide_fg",
      after = "",
    },
    colors = {
      fix = { colors.red },
      todo = { colors.green },
      hack = { colors.peach },
      warn = { colors.yellow },
      perf = { colors.mauve },
      note = { colors.blue },
      test = { colors.sky },
    },
  })

  require("telescope").load_extension("todo-comments")
end

return M
