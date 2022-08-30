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
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          ["[["] = { "@function.outer", "@class.outer" },
        },
        goto_next_end = {
          ["]]"] = { "@function.outer", "@class.outer" },
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
