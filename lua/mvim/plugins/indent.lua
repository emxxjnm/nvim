local M = {
  {
    "lukas-reineke/indent-blankline.nvim",
    branch = "v3",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      indent = {
        char = I.indent.dash,
      },
      scope = {
        enabled = false,
      },
    },
    config = function(_, opts)
      require("ibl").setup(opts)
    end,
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
