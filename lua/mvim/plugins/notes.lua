local M = {
  {
    "dhruvasagar/vim-table-mode",
    cmd = "TableModeToggle",
    keys = { { "<leader>mt", "<Cmd>TableModeToggle<CR>", desc = "MarkDown table mode toggle" } },
  },

  -- markdown preview
  {
    "toppair/peek.nvim",
    build = "deno task --quiet build:fast",
    keys = {
      {
        "<leader>mp",
        function()
          local peek = require("peek")
          if peek.is_open() then
            peek.close()
          else
            peek.open()
          end
        end,
        desc = "Peek (Markdown Preview)",
      },
    },
    opts = { theme = "dark", app = "browser" },
  },
}

return M
