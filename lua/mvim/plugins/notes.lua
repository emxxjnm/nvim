local M = {
  {
    "dhruvasagar/vim-table-mode",
    cmd = "TableModeToggle",
    ft = { "markdown" },
    keys = {
      { "<leader>mt", "<Cmd>TableModeToggle<CR>", desc = "Toggle table mode" },
    },
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    keys = {
      { "<leader>mr", "<Cmd>RenderMarkdown toggle<CR>", desc = "Toggle render markdown" },
    },
    opts = {
      heading = { enabled = false },
      code = {
        sign = false,
        width = "block",
        left_pad = 1,
        right_pad = 1,
      },
      pipe_table = {
        preset = "round",
      },
    },
  },
}

return M
