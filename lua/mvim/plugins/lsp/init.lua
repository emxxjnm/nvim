local M = {
  "neovim/nvim-lspconfig",
  event = { "BufReadPost", "BufNewFile" },
  keys = {
    {
      "<leader>ll",
      function()
        Snacks.win({
          file = vim.lsp.get_log_path(),
          height = 0.9,
          width = 0.9,
          border = Mo.C.border,
        })
      end,
      desc = "Lsp Log",
    },
    { "<leader>li", "<CMD>LspInfo<CR>", desc = "Lsp Info" },
    { "<leader>lr", "<CMD>LspRestart<CR>", desc = "Lsp Restart" },
  },
  opts = {
    servers = {
      gopls = {
        settings = {
          gopls = {
            gofumpt = true,
            codelenses = {
              gc_details = false,
              generate = true,
              regenerate_cgo = true,
              run_govulncheck = true,
              test = true,
              tidy = true,
              upgrade_dependency = true,
              vendor = true,
            },
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
            analyses = {
              fieldalignment = true,
              nilness = true,
              unusedparams = true,
              unusedwrite = true,
              useany = true,
            },
            usePlaceholders = true,
            completeUnimported = true,
            staticcheck = true,
            directoryFilters = { "-.git", "-node_modules", "-.nvim" },
            semanticTokens = true,
          },
        },
      },
      rust_analyzer = {
        settings = {
          ["rust-analyzer"] = {
            check = {
              features = "all",
              command = "clippy",
              extraArgs = { "--no-deps" },
            },
          },
        },
      },
      pyright = {},
      nil_ls = {},
      lua_ls = {
        settings = {
          Lua = {
            format = { enable = false },
            workspace = { checkThirdParty = false },
          },
        },
      },
      volar = {
        init_options = {
          vue = { hybridMode = false },
        },
        filetypes = {
          "vue",
          "typescript",
          "javascript",
          "javascriptreact",
          "typescriptreact",
        },
      },
    },
  },
  config = function(_, opts)
    require("mvim.plugins.lsp.diagnostic").setup()

    Mo.U.lsp.on_attach(function(client, buffer)
      require("mvim.plugins.lsp.keymaps").on_attach(client, buffer)
      -- require("mvim.plugins.lsp.codelens").on_attach(client, buffer)
    end)

    for server, server_opts in pairs(opts.servers) do
      local config = Mo.U.lsp.resolve_config(server_opts or {})
      require("lspconfig")[server].setup(config)
    end
  end,
}

return M
