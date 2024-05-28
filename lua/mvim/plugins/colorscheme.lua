local M = {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  config = function()
    local transparent = require("mvim.config").transparent

    require("catppuccin").setup({
      flavour = transparent and "mocha" or "macchiato",
      transparent_background = transparent,
      styles = {
        keywords = { "bold" },
        functions = { "italic" },
      },
      integrations = {
        alpha = false,
        neogit = false,
        nvimtree = false,
        illuminate = false,
        treesitter_context = false,
        rainbow_delimiters = false,
        dropbar = { enabled = false },
        mason = true,
        noice = true,
        notify = true,
        neotest = true,
        which_key = true,
        telescope = { style = transparent and nil or "nvchad" },
      },
      custom_highlights = function(colors)
        return {
          -- custom
          PanelHeading = {
            fg = colors.lavender,
            bg = transparent and colors.none or colors.crust,
            style = { "bold", "italic" },
          },

          -- treesitter-context
          TreesitterContextLineNumber = transparent and {
            fg = colors.rosewater,
          } or { fg = colors.subtext0, bg = colors.mantle },

          -- lazy.nvim
          LazyH1 = {
            bg = transparent and colors.none or colors.peach,
            fg = transparent and colors.lavender or colors.base,
            style = { "bold" },
          },
          LazyButton = {
            bg = colors.none,
            fg = transparent and colors.overlay0 or colors.subtext0,
          },
          LazyButtonActive = {
            bg = transparent and colors.none or colors.overlay1,
            fg = transparent and colors.lavender or colors.base,
            style = { "bold" },
          },
          LazySpecial = { fg = colors.green },

          CmpItemMenu = { fg = colors.subtext1 },
          MiniIndentscopeSymbol = { fg = colors.overlay0 },

          FloatBorder = {
            fg = transparent and colors.blue or colors.mantle,
            bg = transparent and colors.none or colors.mantle,
          },

          FloatTitle = {
            fg = transparent and colors.lavender or colors.base,
            bg = transparent and colors.none or colors.lavender,
          },
        }
      end,
    })
    vim.cmd.colorscheme("catppuccin")
    local palette = require("catppuccin.palettes").get_palette()
    require("mvim.config").filling_pigments(palette)
  end,
}

return M
