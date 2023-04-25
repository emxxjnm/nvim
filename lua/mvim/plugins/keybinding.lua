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
      breadcrumb = I.navigation.breadcrumb,
      separator = I.navigation.arrows .. " ",
      group = "",
    },
    window = {
      border = mo.styles.border,
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
        b = { name = I.misc.buffer .. " Buffer" },
        c = { name = I.misc.code .. " Code" },
        d = { name = I.dap.bug .. " Debugger" },
        f = { name = I.misc.search .. " Find" },
        g = { name = I.git.git .. " Git" },
        l = { name = I.lsp.lsp .. " LSP" },
        m = { name = I.misc.markdown .. " Markdown" },
        t = { name = I.misc.terminal .. " Terminal" },
      },
    })
  end,
}

return M
