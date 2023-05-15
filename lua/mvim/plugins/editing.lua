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
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = { "hrsh7th/nvim-cmp" },
    opts = {
      check_ts = true,
      ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
      fast_wrap = { map = "<M-e>" },
    },
    config = function(_, opts)
      local autopairs = require("nvim-autopairs")
      local Rule = require("nvim-autopairs.rule")
      local ts_conds = require("nvim-autopairs.ts-conds")
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")

      require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())

      autopairs.setup(opts)

      autopairs.add_rules({
        -- Typing { when {| -> {{ | }} in Vue files
        Rule("{{", "  }", "vue"):set_end_pair_length(2):with_pair(ts_conds.is_ts_node("text")),

        -- Typing = when () -> () => |
        Rule("%(.*%)%s*%=$", "> {}", { "typescript", "typescriptreact", "javascript", "vue" })
          :use_regex(true)
          :set_end_pair_length(1),
      })
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
    "andymass/vim-matchup",
    event = "BufReadPost",
    keys = {
      { "[%", desc = "Prev match item" },
      { "]%", desc = "Next match item" },
      { "<leader>;", "<plug>(matchup-%)", desc = "Find a match" },
    },
    config = function()
      vim.g.matchup_matchparen_offscreen = {
        method = "popup",
        fullwidth = true,
      }
    end,
  },
}

return M
