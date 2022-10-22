local M = {}

function M.setup()
  local colors = require("catppuccin.palettes").get_palette()

  require("catppuccin").setup({
    flavour = "frappe",
    transparent_background = true,
    styles = {
      functions = { "italic" },
      keywords = { "bold" },
    },
    integrations = {
      nvimtree = true,
      dashboard = false,
      hop = true,
      neotree = true,
      notify = true,
      mason = true,
      which_key = true,
      dap = { enabled = true, enable_ui = true },
    },
    custom_highlights = {
      PanelHeading = { fg = colors.lavender, bold = true },
      IndentBlanklineContextChar = { fg = colors.overlay0 },
    },
  })

  mo.style.palettes = colors
end

return M
