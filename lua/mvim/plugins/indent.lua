local M = {
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPre", "BufNewFile" },
    main = "ibl",
    opts = {
      indent = {
        char = I.indent.dash,
        tab_char = I.indent.dash,
      },
      scope = { enabled = false },
      exclude = {
        filetypes = { "help", "alpha", "neo-tree", "lazy", "mason" },
      },
    },
  },

  {
    "echasnovski/mini.indentscope",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      symbol = I.indent.solid,
      options = {
        try_as_border = true,
        indent_at_cursor = false,
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "help", "alpha", "neo-tree", "lazy", "mason" },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },
}

return M
