local M = {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "b0o/SchemaStore.nvim",
      "hrsh7th/cmp-nvim-lsp",
      { "folke/neodev.nvim", opts = { experimental = { pathStrict = true } } },
      {
        "williamboman/mason.nvim",
        cmd = "Mason",
        opts = {
          ui = {
            width = 0.8,
            height = 0.8,
            border = mo.style.border.current,
            icons = {
              package_installed = mo.style.icons.misc.installed,
              package_pending = mo.style.icons.misc.pedding,
              package_uninstalled = mo.style.icons.misc.uninstalled,
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
        eslint = {},
        gopls = {},
        jsonls = {
          -- lazy-load schemastore when needed
          on_new_config = function(new_config)
            new_config.settings.json.schemas = require("schemastore").json.schemas()
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
        sumneko_lua = {
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
            "sass",
            "scss",
            "javascriptreact",
            "typescriptreact",
            "vue",
          },
        },
        tsserver = {},
        vimls = {},
        volar = {},
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
      setup = {},
    },
    config = function(_, opts)
      -- resolve config
      local json_decode = vim.json and vim.json.decode or vim.fn.json_decode

      ---This function allows reading a per project `settings.josn` file
      ---in the `.vim` directory of the project
      ---@param client table<string, any> lsp client
      ---@return boolean
      local function common_on_init(client)
        local settings = client.workspace_folders[1].name
          .. "/"
          .. mo.config.metadir
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

        if not overrides then
          return true
        end

        for name, config in pairs(overrides) do
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
        return require("cmp_nvim_lsp").default_capabilities()
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

      require("mason-lspconfig").setup({ ensure_installed = vim.tbl_keys(opts.servers) })
      require("mason-lspconfig").setup_handlers({
        function(server)
          local config = resolve_config(server, opts.servers[server] or {})
          if opts.setup[server] then
            if opts.setup[server](server, config) then
              return
            end
          elseif opts.setup["*"] then
            if opts.setup["*"] then
              return
            end
          end
          require("lspconfig")[server].setup(config)
        end,
      })
    end,
  },

  {
    "ray-x/lsp_signature.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    opts = {
      bind = true,
      fix_pos = false,
      hint_scheme = "Comment",
      handler_opts = { border = mo.style.border.current },
    },
  },

  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "BufReadPre",
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
