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
    ft = {
      "vue",
      "tsx",
      "jsx",
      "html",
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
    },
    opts = {},
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      fast_wrap = { map = "<M-e>" },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    opts = { mode = "cursor", max_lines = 3 },
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

  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = { "BufReadPost" },
    keys = {
      {
        "[l",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Prev todo comment",
      },
      {
        "]l",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Next todo comment",
      },
      { "<leader>fl", "<Cmd>TodoTelescope<CR>", desc = "List todo" },
    },
    opts = function()
      local palette = require("mvim.config").palette
      return {
        keywords = {
          FIX = { icon = "", color = "fix", alt = { "FIXME", "FIXIT", "ISSUE" } },
          TODO = { icon = "", color = "todo" },
          HACK = { icon = "", color = "hack" },
          WARN = { icon = "", color = "warn", alt = { "WARNING", "XXX" } },
          PERF = { icon = "", color = "perf", alt = { "OPTIM" } },
          NOTE = { icon = "", color = "note" },
          TEST = { icon = "", color = "test", alt = { "PASSED", "FAILED" } },
        },
        highlight = {
          before = "",
          keyword = "wide_fg",
          after = "",
        },
        colors = {
          fix = { palette.red },
          todo = { palette.green },
          hack = { palette.peach },
          warn = { palette.yellow },
          perf = { palette.mauve },
          note = { palette.blue },
          test = { palette.sky },
        },
      }
    end,
  },
}

return M
