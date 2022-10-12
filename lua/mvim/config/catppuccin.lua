local M = {}

function M.setup()
  local colors = require("catppuccin.palettes").get_palette()

  require("catppuccin").setup({
    compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
    transparent_background = true,
    term_colors = false,
    dim_inactive = {
      enabled = false,
      shade = "dark",
      percentage = 0,
    },
    styles = {
      comments = { "italic" },
      conditionals = { "italic" },
      loops = {},
      functions = { "bold", "italic" },
      keywords = { "bold" },
      strings = {},
      variables = {},
      numbers = {},
      booleans = {},
      properties = {},
      types = {},
      operators = {},
    },
    integrations = {
      treesitter = true,
      native_lsp = {
        enabled = true,
        virtual_text = {
          errors = { "italic" },
          hints = { "italic" },
          warnings = { "italic" },
          information = { "italic" },
        },
        underlines = {
          errors = { "underline" },
          hints = { "underline" },
          warnings = { "underline" },
          information = { "underline" },
        },
      },
      cmp = true,
      gitsigns = true,
      telescope = true,
      nvimtree = true,
      neotree = true,
      which_key = true,
      dap = {
        enabled = true,
        enable_ui = true,
      },
      indent_blankline = {
        enabled = true,
        colored_indent_levels = false,
      },
      hop = true,
      symbols_outline = false,
    },
    color_overrides = {},
    highlight_overrides = {
      all = {
        FloatBorder = { fg = colors.surface2 },
        TelescopeBorder = { fg = colors.surface2 },
        WhichKeyBorder = { fg = colors.surface2 },
      },
    },
  })
end

return M
