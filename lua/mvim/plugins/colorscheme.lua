local M = {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  opts = {
    flavour = mo.styles.transparent and "mocha" or "macchiato",
    transparent_background = mo.styles.transparent,
    styles = {
      keywords = { "bold" },
      functions = { "italic" },
    },
    integrations = {
      alpha = false,
      neogit = false,
      nvimtree = false,
      illuminate = false,
      rainbow_delimiters = false,
      dropbar = { enabled = false },
      mason = true,
      noice = true,
      notify = true,
      neotree = true,
      neotest = true,
      which_key = true,
      telescope = { style = mo.styles.transparent and nil or "nvchad" },
    },
    custom_highlights = function(colors)
      return {
        -- custom
        PanelHeading = {
          fg = colors.lavender,
          bg = mo.styles.transparent and colors.none or colors.crust,
          style = { "bold", "italic" },
        },

        -- lazy.nvim
        LazyH1 = {
          bg = mo.styles.transparent and colors.none or colors.peach,
          fg = mo.styles.transparent and colors.lavender or colors.base,
          style = { "bold" },
        },
        LazyButton = {
          bg = colors.none,
          fg = mo.styles.transparent and colors.overlay0 or colors.subtext0,
        },
        LazyButtonActive = {
          bg = mo.styles.transparent and colors.none or colors.overlay1,
          fg = mo.styles.transparent and colors.lavender or colors.base,
          style = { "bold" },
        },
        LazySpecial = { fg = colors.sapphire },

        CmpItemMenu = { fg = colors.subtext1 },
        MiniIndentscopeSymbol = { fg = colors.overlay0 },

        FloatBorder = {
          fg = mo.styles.transparent and colors.blue or colors.mantle,
          bg = mo.styles.transparent and colors.none or colors.mantle,
        },

        FloatTitle = {
          fg = mo.styles.transparent and colors.lavender or colors.base,
          bg = mo.styles.transparent and colors.none or colors.lavender,
        },
      }
    end,
    color_overrides = {
      mocha = {
        red = "#f07c82",
        blue = "#70a1ff",
        green = "#7bed9f",
        yellow = "#ffeaa7",

        sky = "#5ef1ff",
        pink = "#ffacfc",
        peach = "#ffbe76",
        -- mauve = "#b76cfd",
        -- mauve = "#cba6f7"
        -- mauve = "#ce96fb",
      },
    },
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)

    vim.cmd.colorscheme("catppuccin")
    mo.styles.palettes = require("catppuccin.palettes").get_palette()
  end,
}

return M
