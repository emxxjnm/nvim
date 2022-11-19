local M = {}

function M.setup()
  local colors = require("catppuccin.palettes").get_palette()

  require("catppuccin").setup({
    flavour = "mocha",
    transparent_background = true,
    styles = {
      keywords = { "bold" },
      functions = { "italic" },
    },
    integrations = {
      leap = true,
      mason = true,
      neotree = true,
      nvimtree = true,
      which_key = true,
      dashboard = false,
      dap = { enabled = true, enable_ui = true },
    },
    custom_highlights = {
      -- custom
      PanelHeading = { fg = colors.lavender, bold = true },

      -- overrider
      FloatBorder = { fg = colors.overlay1 },
      TelescopeBorder = { fg = colors.overlay1 },
      WhichKeyBorder = { fg = colors.overlay1 },
      NeoTreeFloatBorder = { fg = colors.overlay1 },

      IndentBlanklineContextChar = { fg = colors.overlay0 },
    },
  })

  mo.style.palettes = colors
end

return M
