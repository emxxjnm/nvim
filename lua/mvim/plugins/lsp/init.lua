local Util = require("mvim.util")

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
      { "folke/neodev.nvim", opts = {} },
    },
    opts = {
      servers = {
        bashls = {},
        dockerls = {},
        cssls = {},
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
        jsonls = {
          settings = {
            json = {
              format = { enable = true },
              validate = { enable = true },
            },
          },
        },
        -- pylsp = {},
        -- stylelint_lsp = {
        --   filetypes = { "css", "less", "scss", "vue" },
        --   settings = {
        --     stylelintplus = {
        --       autoFixOnSave = true,
        --       autoFixOnFormat = true,
        --     },
        --   },
        -- },
        lua_ls = {
          settings = {
            Lua = {
              format = { enable = false },
              telemetry = { enable = false },
              workspace = { checkThirdParty = false },
            },
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

      require("mvim.plugins.lsp.ui").setup()

      Util.lsp.on_attach(function(client, buffer)
        require("mvim.plugins.lsp.keybinds").on_attach(client, buffer)

        require("mvim.plugins.lsp.codelens").on_attach(client, buffer)
        require("mvim.plugins.lsp.highlight").on_attach(client, buffer)
      end)

      ---@param server string lsp server name
      local function setup_server(server)
        local config = Util.lsp.resolve_config(server, opts.servers[server] or {})
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
      local all_mlsp_servers =
        vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)

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

      mlsp.setup({ ensure_installed = ensure_installed, handlers = { setup_server } })
    end,
  },
}

return M
