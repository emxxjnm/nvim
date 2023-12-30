local M = {
  {
    "numToStr/Comment.nvim",
    keys = {
      { "gc", mode = { "n", "v" }, desc = "Linewise comment" },
      { "gb", mode = { "n", "v" }, desc = "Blockwise comment" },
    },
    dependencies = {
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
        opts = { enable_autocmd = false },
      },
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
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local autopairs = require("nvim-autopairs")
      autopairs.setup({
        check_ts = true,
        fast_wrap = { map = "<C-e>" },
      })
      -- local ok, cmp = pcall(require, "cmp")
      -- if ok then
      --   local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      --   cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      -- end
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPost",
    opts = { mode = "cursor", max_lines = 1 },
  },

  {
    "kylechui/nvim-surround",
    keys = {
      { "ys", desc = "Add surround" },
      { "ds", desc = "Delete surround" },
      { "cs", desc = "Replace surround" },
    },
    opts = { move_cursor = false },
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
