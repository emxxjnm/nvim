local M = {
  {
    "dhruvasagar/vim-table-mode",
    cmd = "TableModeToggle",
    ft = { "markdown" },
    keys = {
      { "<leader>mt", "<Cmd>TableModeToggle<CR>", desc = "MarkDown table mode toggle" },
    },
  },

  -- markdown preview
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    keys = {
      { "<leader>mp", "<Cmd>MarkdownPreviewToggle<CR>", desc = "Markdown Preview" },
    },
  },
}

return M
