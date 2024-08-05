local M = {
  {
    "dhruvasagar/vim-table-mode",
    cmd = "TableModeToggle",
    ft = { "markdown" },
    keys = {
      { "<leader>mt", "<Cmd>TableModeToggle<CR>", desc = "MarkDown table mode toggle" },
    },
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    keys = {
      { "<leader>mr", "<Cmd>RenderMarkdown toggle<CR>", desc = "Render markdown" },
    },
    opts = {
      heading = { enabled = false },
      code = {
        sign = false,
        width = "block",
        left_pad = 1,
        right_pad = 1,
      },
    },
  },
}

return M
