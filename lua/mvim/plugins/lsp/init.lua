local M = {
  {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      {
        "neovim/nvim-lspconfig",
        keys = {
          { "<leader>ll", "<CMD>LspLog<CR>", desc = "Lsp Log" },
          { "<leader>li", "<CMD>LspInfo<CR>", desc = "Lsp Info" },
          { "<leader>lr", "<CMD>LspRestart<CR>", desc = "Lsp Restart" },
        },
      },
      "b0o/SchemaStore.nvim",
      {
        "folke/neodev.nvim",
        opts = { experimental = { pathStrict = true } },
      },
      {
        "hrsh7th/cmp-nvim-lsp",
        cond = function()
          return require("mvim.utils").has("nvim-cmp")
        end,
      },
      {
        "williamboman/mason.nvim",
        cmd = "Mason",
        opts = {
          ui = {
            width = 0.8,
            height = 0.8,
            border = mo.styles.border,
            icons = {
              package_installed = mo.styles.icons.plugin.installed,
              package_pending = mo.styles.icons.plugin.pedding,
              package_uninstalled = mo.styles.icons.plugin.uninstalled,
            },
            keymaps = { apply_language_filter = "f" },
          },
        },
      },
    },
    opts = {
      servers = {
        bashls = {},
        dockerls = {},
        cssls = {},
        eslint = {
          on_attach = function()
            require("mvim.utils").augroup("AutoFixOnSave", {
              event = "BufWritePre",
              pattern = { "*.ts", "*.tsx", "*.js", "*.jsx", "*.vue" },
              command = "EslintFixAll",
              desc = "Automatically execute `eslint fix` on save",
            })
          end,
        },
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                generate = true,
                gc_details = false,
                test = true,
                tidy = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                unusedparams = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = { "-node_modules" },
            },
          },
        },
        jsonls = {
          on_new_config = function(new_config)
            local schemas = require("schemastore").json.schemas()
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
            vim.list_extend(new_config.settings.json.schemas, schemas, 1, #schemas)
          end,
          settings = {
            json = {
              format = { enable = true },
              validate = { enable = true },
            },
          },
        },
        pylsp = {},
        stylelint_lsp = {
          filetypes = { "html", "css", "less", "scss", "vue" },
          settings = {
            stylelintplus = {
              autoFixOnSave = true,
              autoFixOnformat = true,
            },
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              format = { enable = false },
              telemetry = { enable = false },
              workspace = { checkThirdParty = false },
            },
          },
        },
        unocss = {
          filetypes = {
            "html",
            "javascriptreact",
            "typescriptreact",
            "vue",
          },
        },
        vimls = {},
        volar = {
          -- take over Typescript
          filetypes = {
            "vue",
            "typescript",
            "javascript",
            "javascriptreact",
            "typescriptreact",
          },
        },
        yamlls = {
          settings = {
            yaml = {
              validate = true,
              format = { enable = true },
            },
          },
        },
      },
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be setup with lspconfig
      ---@type table<string, fun(server:string, opts: table):boolean?>
      setup = {
        -- example to setup with typescript.nvim
        -- tsserver = function(_, opts)
        --   require("typescript").setup({ server = opts })
        --   return true
        -- end,
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
      },
    },
    config = function(_, opts)
      require("mvim.plugins.lsp.diagnostics").setup()

      require("mvim.plugins.lsp.handlers").setup()

      require("mvim.utils").on_attach(function(client, buffer)
        require("mvim.plugins.lsp.format").on_attach(client, buffer)
        require("mvim.plugins.lsp.keybinds").on_attach(client, buffer)

        require("mvim.plugins.lsp.codelens").on_attach(client, buffer)
        require("mvim.plugins.lsp.highlight").on_attach(client, buffer)
      end)

      local function setup_server(server)
        local config = require("mvim.utils").resolve_config(server, opts.servers[server] or {})
        if opts.setup[server] then
          if opts.setup[server](server, config) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, config) then
            return
          end
        end
        require("lspconfig")[server].setup(config)
      end

      local mlsp_available, mlsp = pcall(require, "mason-lspconfig")
      local all_mlsp_servers = {}
      if mlsp_available then
        all_mlsp_servers =
          vim.tbl_keys(require("mason-lspconfig.mappings.server").package_to_lspconfig)
      end

      local ensure_installed = {} ---@type string[]
      for server, server_opts in pairs(opts.servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
          if server_opts.mason == false or not vim.tbl_contains(all_mlsp_servers, server) then
            setup_server(server)
          else
            ensure_installed[#ensure_installed + 1] = server
          end
        end
      end

      if mlsp_available then
        mlsp.setup({ ensure_installed = ensure_installed })
        mlsp.setup_handlers({ setup_server })
      end
    end,
  },

  {
    "ray-x/lsp_signature.nvim",
    event = "BufReadPost",
    opts = {
      bind = true,
      hint_scheme = "Comment",
      handler_opts = { border = mo.styles.border },
    },
  },

  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = function()
      local nls = require("null-ls")

      return {
        border = mo.styles.border,
        sources = {
          -- lua
          nls.builtins.formatting.stylua.with({
            condition = function(utils)
              return vim.fn.executable("stylua")
                and utils.root_has_file({ "stylua.toml", ".stylua.toml" })
            end,
          }),

          -- shell
          nls.builtins.diagnostics.shellcheck,
          nls.builtins.formatting.shfmt.with({
            extra_args = { "-i", "2", "-ci", "-bn" },
          }),

          -- markdown
          nls.builtins.formatting.markdownlint,
          nls.builtins.diagnostics.markdownlint,
        },
        root_dir = require("null-ls.utils").root_pattern("Makefile", ".vim", ".git"),
      }
    end,
  },
}

return M
