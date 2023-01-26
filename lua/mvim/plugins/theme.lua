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

        LazyH1 = { bg = "NONE", fg = colors.lavender, style = { "bold" } },
        LazyButton = { bg = "NONE", fg = colors.overlay0 },
        LazyButtonActive = { bg = "NONE", fg = colors.lavender, style = { " bold" } },
        LazySpecial = { fg = colors.sapphire },

        -- LazyH1 = { bg = colors.peach, fg = colors.base, style = { "bold" } },
        -- LazyButton = { bg = "NONE", fg = colors.subtext0 },
        -- LazyButtonActive = { bg = colors.overlay1, fg = colors.base, style = { " bold" } },
        -- LazySpecial = { fg = colors.sapphire },

        -- overrider
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
