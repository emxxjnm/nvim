local M = {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  build = ":CatppuccinCompile",
  opts = {
    flavour = "mocha",
    transparent_background = mo.styles.transparent,
    styles = {
      keywords = { "bold" },
      functions = { "italic" },
    },
    integrations = {
      leap = true,
      mason = true,
      neotree = true,
      which_key = true,
      nvimtree = false,
      dashboard = false,
      ts_rainbow = false,
      dap = { enabled = true, enable_ui = true },
    },
    custom_highlights = function(colors)
      return {
        -- custom
        PanelHeading = { fg = colors.lavender, style = { "bold", "italic" } },

        -- lazy.nvim
        LazyH1 = {
          bg = mo.styles.transparent and "NONE" or colors.peach,
          fg = mo.styles.transparent and colors.lavender or colors.base,
          style = { "bold" },
        },
        LazyButton = {
          bg = "NONE",
          fg = mo.styles.transparent and colors.overlay0 or colors.subtext0,
        },
        LazyButtonActive = {
          bg = mo.styles.transparent and "NONE" or colors.overlay1,
          fg = mo.styles.transparent and colors.lavender or colors.base,
          style = { " bold" },
        },
        LazySpecial = { fg = colors.sapphire },

        -- gitsigns
        GitSignsAddLn = mo.styles.transparent and { bg = colors.none } or { link = "DiffAdd" },
        GitSignsChangeLn = mo.styles.transparent and { bg = colors.none } or {
          link = "DiffChange",
        },
        GitSignsAddInline = mo.styles.transparent and {
          fg = colors.green,
          bg = colors.none,
          style = { "bold" },
        } or { link = "DiffAdd" },
        GitSignsDeleteInline = mo.styles.transparent and {
          fg = colors.red,
          bg = colors.none,
          style = { "bold" },
        } or { link = "DiffDelete" },
        GitSignsChangeInline = mo.styles.transparent and {
          fg = colors.yellow,
          bg = colors.none,
          style = { "bold" },
        } or { link = "DiffChange" },

        GitSignsDeleteVirtLn = mo.styles.transparent and { fg = colors.red, bg = colors.none } or {
          link = "DiffDelete",
        },
        GitSignsDeleteVirtLnInLine = mo.styles.transparent and {
          fg = colors.red,
          bg = colors.none,
        } or {
          link = "TermCursor",
        },

        -- overrider
        CmpItemMenu = { fg = colors.subtext1 },
        FloatBorder = { fg = colors.overlay1 },
        TelescopeBorder = { fg = colors.overlay1 },
        WhichKeyBorder = { fg = colors.overlay1 },
        NeoTreeFloatBorder = { fg = colors.overlay1 },
        LspInfoBorder = { fg = colors.overlay1 },

        IndentBlanklineContextChar = { fg = colors.overlay0 },
      }
    end,
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme("catppuccin")
  end,
}

return M
