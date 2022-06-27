local M = {}

function M.setup()
  require("catppuccin").setup({
    transparent_background = true,
    term_colors = false,
    styles = {
      comments = "italic",
      conditionals = "italic",
      loops = "NONE",
      functions = "italic,bold",
      keywords = "bold",
      strings = "NONE",
      variables = "NONE",
      numbers = "NONE",
      booleans = "NONE",
      properties = "NONE",
      types = "NONE",
      operators = "NONE",
    },
    integrations = {
      treesitter = true,
      native_lsp = {
        enabled = true,
        virtual_text = {
          errors = "italic",
          hints = "italic",
          warnings = "italic",
          information = "italic",
        },
        underlines = {
          errors = "underline",
          hints = "underline",
          warnings = "underline",
          information = "underline",
        },
      },
      lsp_trouble = true,
      cmp = true,
      gitsigns = true,
      telescope = true,
      nvimtree = {
        enabled = true,
        show_root = true,
        transparent_panel = false,
      },
      indent_blankline = {
        enabled = true,
        colored_indent_levels = false,
      },
      dashboard = false,
      neogit = true,
      bufferline = true,
      markdown = true,
      hop = true,
      notify = false,
      symbols_outline = false,
    },
  })

  vim.g.catppuccin_flavour = "macchiato"
  vim.cmd("colorscheme catppuccin")
end

return M
