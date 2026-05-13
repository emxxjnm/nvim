local p = require("catppuccin.palettes").get_palette()

return {
  palette = {
    pink     = p.pink,
    lavender = p.lavender,
    sapphire = p.sapphire,
    yellow   = p.yellow,
    green    = p.green,
    red      = p.red,
    blue     = p.blue,
    teal     = p.teal,
    peach    = p.peach,
    mauve    = p.mauve,
    muted    = p.surface1,
    subtle   = p.surface0,
  },
  lualine_theme = "catppuccin-nvim",
  bufferline_highlights = function(overrides)
    return require("catppuccin.special.bufferline").get_theme({
      custom = { all = overrides },
    })
  end,
}
