local M = {}

function M.setup()
  require("nvim-treesitter.configs").setup({
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
    highlight = {
      enable = true,
    },
    indent = {
      enable = true,
      disable = { "yaml", "python" },
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<CR>", -- normal mode
        node_incremental = "<Tab>", -- visual mode
        scope_incremental = "<CR>", -- visual mode
        node_decremental = "<BS>", -- visual mode
      },
    },
    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },
    textobjects = {
      select = {
        enable = true,
        include_surrounding_whitespace = true,
        keymaps = {
          ["ac"] = { query = "@function.outer", desc = "TS: all class" },
          ["ic"] = { query = "@function.inner", desc = "TS: inner class" },
          ["af"] = { query = "@function.outer", desc = "TS: all function" },
          ["if"] = { query = "@function.inner", desc = "TS: inner function" },
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          ["]c"] = "@class.outer",
          ["[f"] = "@function.outer",
        },
        goto_previous_start = {
          ["[c"] = "@class.outer",
          ["[f"] = "@function.outer",
        },
      },
    },
    autotag = {
      enable = true,
      filetypes = {
        "vue",
        "tsx",
        "jsx",
        "xml",
        "html",
        "javascript",
        "typescript",
        "javascriptreact",
        "typescriptreact",
      },
    },
    matchup = {
      enable = true,
    },
  })
end

return M
