local M = {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    plugins = {
      presets = {
        operators = false,
        motions = false,
        text_objects = false,
        windows = false,
        nav = false,
        z = true,
        g = false,
      },
    },
    icons = {
      breadcrumb = "",
      separator = " ",
      group = "",
    },
    window = {
      border = require("mvim.config").get_border(),
    },
    layout = {
      spacing = 5,
      align = "center",
    },
    show_help = false,
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    wk.register({
      ["]"] = { name = "Next" },
      ["["] = { name = "Prev" },
      ["<leader>"] = {
        b = { name = " Buffer" },
        c = { name = " Code" },
        d = { name = " Debug" },
        f = { name = " Find" },
        g = { name = " Git" },
        l = { name = " LSP" },
        m = { name = " Markdown" },
        n = { name = "󰵚 Notification" },
        t = { name = " Test" },
        o = { name = "󰘵 Option" },
      },
    })
  end,
}

return M
