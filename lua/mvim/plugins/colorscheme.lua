local M = {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  build = ":CatppuccinCompile",
  opts = {
    flavour = mo.styles.transparent and "mocha" or "macchiato",
    transparent_background = mo.styles.transparent,
    styles = {
      keywords = { "bold" },
      functions = { "italic" },
    },
    integrations = {
      leap = true,
      mason = true,
      neotree = true,
      neotest = true,
      which_key = true,
      nvimtree = false,
      dashboard = false,
      ts_rainbow = false,
      dap = { enabled = true, enable_ui = true },
    },
    custom_highlights = function(colors)
      local default = {
        -- custom
        PanelHeading = {
          fg = colors.lavender,
          bg = mo.styles.transparent and "NONE" or colors.crust,
          style = { "bold", "italic" },
        },

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

        CmpItemMenu = { fg = colors.subtext1 },
        MiniIndentscopeSymbol = { fg = colors.overlay0 },

        FloatBorder = {
          fg = mo.styles.transparent and colors.overlay1 or colors.mantle,
          bg = mo.styles.transparent and "NONE" or colors.mantle,
        },

        FloatTitle = {
          fg = colors.subtext0,
          bg = mo.styles.transparent and "NONE" or colors.mantle,
        },
      }

      local telescope = {
        TelescopePromptNormal = { bg = colors.crust },
        TelescopePromptTitle = { fg = colors.subtext0 },
        TelescopePromptBorder = { bg = colors.crust, fg = colors.crust },
        TelescopePromptPrefix = { bg = colors.crust, fg = colors.flamingo },

        TelescopeResultsNormal = { bg = colors.mantle },
        TelescopeResultsTitle = { fg = colors.subtext0 },
        TelescopeResultsBorder = { bg = colors.mantle, fg = colors.mantle },

        TelescopePreviewNormal = { bg = colors.crust },
        TelescopePreviewTitle = { fg = colors.subtext0 },
        TelescopePreviewBorder = { bg = colors.crust, fg = colors.crust },
      }

      if not mo.styles.transparent then
        return vim.tbl_extend("keep", default, telescope)
      end

      return default
    end,
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme("catppuccin")
  end,
}

return M
