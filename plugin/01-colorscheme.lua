vim.pack.add({ "https://github.com/catppuccin/nvim" })

require("catppuccin").setup({
  flavour = Mo.C.transparent and "mocha" or "latte",
  transparent_background = Mo.C.transparent,
  float = { transparent = Mo.C.transparent, solid = false },
  styles = { keywords = { "bold" } },
  integrations = {
    alpha = false,
    neogit = false,
    nvimtree = false,
    treesitter_context = false,
    rainbow_delimiters = false,
    mini = { enabled = false },
    dropbar = { enabled = false },
    illuminate = { enabled = false },
    noice = true,
    avante = true,
    neotest = true,
    blink_cmp = true,
    which_key = true,
    nvim_surround = true,
    snacks = { enabled = true, indent_scope_color = "overlay2" },
    telescope = { enabled = false },
  },
  custom_highlights = function(colors)
    return {
      PanelHeading = {
        fg = colors.lavender,
        bg = Mo.C.transparent and colors.none or colors.crust,
        style = { "bold", "italic" },
      },

      FloatBorder = {
        fg = Mo.C.transparent and colors.blue or colors.mantle,
        bg = Mo.C.transparent and colors.none or colors.mantle,
      },

      FloatTitle = {
        fg = Mo.C.transparent and colors.lavender or colors.base,
        bg = Mo.C.transparent and colors.none or colors.lavender,
      },
    }
  end,
})

vim.cmd.colorscheme("catppuccin")

local adapter = require("mvim.palettes.catppuccin")
Mo.C.palette = adapter.palette
Mo.C.theme = {
  lualine = adapter.lualine_theme,
  bufferline_highlights = adapter.bufferline_highlights,
}
