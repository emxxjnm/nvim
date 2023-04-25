local M = {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      { "<Tab>", mode = { "v" }, desc = "Increment selection" },
      { "<BS>", mode = { "n", "v" }, desc = "Schrink selection" },
      { "<CR>", mode = { "n", "v" }, desc = "Increment selection" },
    },
    opts = {
      ensure_installed = {
        "bash",
        "css",
        "dockerfile",
        "dot",
        "gitignore",
        "go",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "python",
        "scss",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vue",
        "yaml",
      },
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<CR>", -- normal mode
          node_incremental = "<Tab>", -- visual mode
          scope_incremental = "<CR>", -- visual mode
          node_decremental = "<BS>", -- visual mode
        },
      },
      context_commentstring = { enable = true, enable_autocmd = false },
      textobjects = {
        select = {
          enable = true,
          keymaps = {
            ["ac"] = { query = "@function.outer", desc = "TS: all class" },
            ["ic"] = { query = "@function.inner", desc = "TS: inner class" },
            ["af"] = { query = "@function.outer", desc = "TS: all function" },
            ["if"] = { query = "@function.inner", desc = "TS: inner function" },
            ["aL"] = { query = "@assignment.lhs", desc = "TS: assignment lhs" },
            ["aR"] = { query = "@assignment.rhs", desc = "TS: assignment rhs" },
          },
        },
        move = {
          enable = true,
          goto_next_start = {
            ["]c"] = { query = "@class.outer", desc = "TS: Next class start" },
            ["]f"] = { query = "@function.outer", desc = "TS: Next function start" },
          },
          goto_previous_start = {
            ["[c"] = { query = "@class.outer", desc = "TS: Prev class start" },
            ["[f"] = { query = "@function.outer", desc = "TS: Prev function start" },
          },
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects" },
      { "JoosepAlviste/nvim-ts-context-commentstring" },
    },
  },

  -- surround
  {
    "kylechui/nvim-surround",
    keys = {
      { "ys", desc = "Add surround" },
      { "ds", desc = "Delete surround" },
      { "cs", desc = "Replace surround" },
    },
    opts = {
      move_cursor = false,
    },
  },
}

return M
