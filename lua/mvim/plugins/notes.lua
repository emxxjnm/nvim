local M = {
  {
    "dhruvasagar/vim-table-mode",
    ft = "markdown",
    cmd = "TableModeToggle",
  },

  -- markdown preview
  {
    "iamcco/markdown-preview.nvim",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    ft = "markdown",
    cmd = { "MarkdownPreview", "MarkdownPreviewToggle" },
  },
}

return M
