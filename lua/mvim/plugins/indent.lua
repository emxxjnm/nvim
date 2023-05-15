local M = {
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      char = I.indent.solid,
      char_list = { I.indent.dash },
      show_current_context = false,
      show_trailing_blankline_indent = false,
      filetype_exclude = { "help", "alpha", "neo-tree", "lazy", "mason" },
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
