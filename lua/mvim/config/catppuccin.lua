local M = {}

function M.setup()
  require("catppuccin").setup({
    dim_inactive = {
      enabled = false,
      shade = "",
      percentage = 0,
    },
    transparent_background = true,
    term_colors = true,
    compile = {
      enabled = true,
      path = vim.fn.stdpath("cache") .. "/catppuccin",
      suffix = "_compiled",
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
      nvimtree = {
        enabled = true,
        show_root = true,
        transparent_panel = true,
      },
      dap = {
        enabled = true,
        enable_ui = true,
      },
      indent_blankline = {
        enabled = true,
        colored_indent_levels = false,
      },
      bufferline = true,
      hop = true,
      symbols_outline = false,
    },
  })
end

return M
