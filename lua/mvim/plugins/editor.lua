local M = {
  {
    "numToStr/Comment.nvim",
    keys = {
      { "gc", mode = { "n", "v" }, desc = "Linewise comment" },
      { "gb", mode = { "n", "v" }, desc = "Blockwise comment" },
    },
    opts = function()
      local ok, tcs = pcall(require, "ts_context_commentstring.integrations.comment_nvim")
      return {
        ignore = "^$",
        pre_hook = ok and tcs and tcs.create_pre_hook() or nil,
      }
    end,
  },

  {
    "windwp/nvim-ts-autotag",
    ft = function()
      local plugin = require("lazy.core.config").spec.plugins["nvim-ts-autotag"]
      local opts = require("lazy.core.plugin").values(plugin, "opts", false)
      return opts.filetypes or {}
    end,
    opts = {
      filetypes = {
        "vue",
        "tsx",
        "jsx",
        "html",
        "javascript",
        "typescript",
        "javascriptreact",
        "typescriptreact",
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPost",
    opts = { mode = "cursor", max_lines = 1 },
  },

  {
    "echasnovski/mini.pairs",
    event = "InsertEnter",
    opts = {},
  },

  {
    "echasnovski/mini.bufremove",
    keys = {
      {
        "<leader>bd",
        function()
          require("mini.bufremove").delete(0)
        end,
        desc = "Delete Buffer",
      },
    },
  },
}

return M
