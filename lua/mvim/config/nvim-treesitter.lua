local M = {}

function M.setup()
  require("nvim-treesitter.configs").setup({
    ensure_installed = {
      "bash",
      "comment",
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
    ignore_install = {},
    highlight = {
      enable = true,
    },
    indent = {
      enable = true,
      disable = { "yaml" },
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
    textobjects = {
      select = {
        enable = true,
        include_surrounding_whitespace = true,
        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          ["]]"] = "@function.outer",
        },
        goto_next_end = {
          ["]["] = "@function.outer",
        },
        goto_previous_start = {
          ["[["] = "@function.outer",
        },
        goto_previous_end = {
          ["[]"] = "@function.outer",
        },
      },
    },
    playground = {
      enable = true,
      disable = {},
      updatetime = 25,
      persist_queries = false,
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
