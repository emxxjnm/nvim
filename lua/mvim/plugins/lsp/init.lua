local M = {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
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
        opts = {
          ui = {
            width = 0.8,
            height = 0.8,
            border = mo.styles.border,
            icons = {
              package_installed = mo.styles.icons.misc.installed,
              package_pending = mo.styles.icons.misc.pedding,
              package_uninstalled = mo.styles.icons.misc.uninstalled,
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
              {
                event = "BufWritePre",
                pattern = { "*.ts", "*.tsx", "*.js", "*.jsx", "*.vue" },
                command = "EslintFixAll",
                desc = "automatically execute `eslint fix` on save",
              },
            })
          end,
        },
        gopls = {},
        jsonls = {
          on_new_config = function(new_config)
            local schemas = require("schemastore").json.schemas()
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
            vim.list_extend(new_config.settings.json.schemas, schemas, 1, #schemas)
          end,
          settings = {
            json = {
              validate = { enable = true },
            },
          },
        },
        pylsp = {},
        sqls = {},
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
              workspace = {
                checkThirdParty = false,
              },
            },
          },
        },
        tailwindcss = {
          filetypes = {
            "html",
            "css",
            "less",
            "scss",
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
              schemas = {
                ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose.yml",
                ["https://json.schemastore.org/pre-commit-config.json"] = ".pre-commit-config.yaml",
                kubernetes = "/*.k8s.yaml",
              },
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
      local json_decode = vim.json and vim.json.decode or vim.fn.json_decode

      ---This function allows reading a per project `settings.josn` file
      ---in the `.vim` directory of the project
      ---@param client table<string, any> lsp client
      ---@return boolean
      local function common_on_init(client)
        local settings = client.workspace_folders[1].name
          .. "/"
          .. mo.settings.metadir
          .. "/settings.json"
        if vim.fn.filereadable(settings) == 0 then
          return true
        end

        local ok, json = pcall(vim.fn.readfile, settings)
        if not ok then
          vim.notify_once(
            "LSP init: read file `settings.json` failed",
            vim.log.levels.ERROR,
            { title = "LSP Settings" }
          )
          return true
        end

        local status, overrides = pcall(json_decode, table.concat(json, "\n"))
        if not status then
          vim.notify_once(
            "LSP init: unmarshall `settings.json` file failed",
            vim.log.levels.ERROR,
            { title = "LSP Settings" }
          )
          return true
        end

        for name, config in pairs(overrides or {}) do
          if name == client.name then
            client.config = vim.tbl_deep_extend("force", client.config, config)
            client.notify("workspace/didChangeConfiguration")

            vim.schedule(function()
              local path = vim.fn.fnamemodify(settings, ":~:.")
              local msg = "loaded local settings for " .. client.name .. "from " .. path
              vim.notify_once(msg, vim.log.levels.INFO, { title = "LSP Settings" })
            end)
          end
        end
        return true
      end

      local function common_capabilities()
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        -- Tell the server the capability of foldingRange :: nvim-ufo
        capabilities.textDocument.foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true,
        }
        return require("cmp_nvim_lsp").default_capabilities(capabilities)
      end

      local function resolve_config(name, ...)
        local defaults = {
          on_init = common_on_init,
          capabilities = common_capabilities(),
        }

        local has_provider, cfg = pcall(require, "mvim.plugins.lsp.providers." .. name)
        if has_provider then
          defaults = vim.tbl_deep_extend("force", defaults, cfg) or {}
        end

        defaults = vim.tbl_deep_extend("force", defaults, ...) or {}

        return defaults
      end

      require("mvim.plugins.lsp.diagnostics").setup()

      require("mvim.plugins.lsp.handlers").setup()

      require("mvim.utils").on_attach(function(client, buffer)
        require("mvim.plugins.lsp.format").on_attach(client, buffer)
        require("mvim.plugins.lsp.keybinds").on_attach(client, buffer)

        require("mvim.plugins.lsp.codelens").on_attach(client, buffer)
        require("mvim.plugins.lsp.highlight").on_attach(client, buffer)
      end)

      local function setup_server(server)
        local config = resolve_config(server, opts.servers[server] or {})
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

      local mlsp = require("mason-lspconfig")
      local available = mlsp.get_available_servers()

      local ensure_installed = {} ---@type string[]
      for server, server_opts in pairs(opts.servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
          if server_opts.mason == false or not vim.tbl_contains(available, server) then
            setup_server(server)
          else
            ensure_installed[#ensure_installed + 1] = server
          end
        end
      end

      mlsp.setup({ ensure_installed = ensure_installed })
      mlsp.setup_handlers({ setup_server })
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
