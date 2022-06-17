require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "bash",
    "comment",
    "css",
    "dockerfile",
    "dot",
    "go",
    "html",
    "javascript",
    "json",
    "json5",
    "jsonc",
    "lua",
    "markdown",
    "python",
    "query",
    "scss",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "vue",
    "yaml",
  },
  sync_install = false,
  ignore_install = {},
  highlight = {
    enable = true,
    disable = {},
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
    disable = { "python", "yaml" },
  },
  textobjects = {
    swap = {
      enable = false,
    },
    select = {
      enable = false,
      lookahead = true,
    },
    move = {
      enable = true,
      set_jumps = false,
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
    lsp_interop = {
      enable = false,
      border = "none",
      peek_definition_code = {
        ["<leader>pf"] = "@function.outer",
        ["<leader>pF"] = "@class.outer",
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
    filetype = {
      "html",
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
      "vue",
      "tsx",
      "jsx",
      "xml",
      "markdown",
    },
  },
  matchup = {
    enable = true,
  },
  context = {
    enable = true,
  },
})
