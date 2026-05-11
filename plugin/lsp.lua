-- Standalone keymaps (don't need lspconfig loaded)
-- stylua: ignore start
vim.keymap.set("n", "<leader>ll", function()
  Snacks.win({ file = vim.lsp.log.get_filename(), height = 0.9, width = 0.9, border = Mo.C.border }):set_title("LSP log", "center")
end, { desc = "Lsp Log" })
vim.keymap.set("n", "<leader>lr", "<CMD>LspRestart<CR>", { desc = "Lsp Restart" })
vim.keymap.set("n", "<leader>li", function() Snacks.picker.lsp_config({ configured = true }) end, { desc = "Lsp Info" })
-- stylua: ignore end

-- BufReadPost/BufNewFile: load lspconfig and configure servers
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("mvim_lsp_setup", { clear = true }),
  once = true,
  callback = function()
    vim.pack.add({ "https://github.com/neovim/nvim-lspconfig" })

    require("mvim.lsp").setup_diagnostics()

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("mvim_lsp_attach", { clear = true }),
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client then
          require("mvim.lsp").on_attach(client, args.buf)
        end
      end,
    })

    local capabilities = vim.tbl_deep_extend(
      "force",
      vim.lsp.protocol.make_client_capabilities(),
      { workspace = { fileOperations = { didRename = true, willRename = true } } }
    )

    local function get_vue_language_server_path()
      local exe = vim.fn.exepath("vue-language-server")
      if exe == "" then
        return ""
      end

      local real = vim.uv.fs_realpath(exe) or exe

      local pkg = real:match("(.+/@vue/language%-server)/")
      if pkg then
        return pkg
      end

      local prefix = real:match("(.+)/bin/[^/]+$")
      if prefix then
        local p = prefix .. "/lib/language-tools/packages/language-server"
        if vim.uv.fs_stat(p) then
          return p
        end
        p = prefix .. "/lib/node_modules/@vue/language-server"
        if vim.uv.fs_stat(p) then
          return p
        end
      end

      return ""
    end

    local servers = {
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
            files = {
              exclude = {
                ".git",
                ".direnv",
                "target",
              },
            },
          },
        },
      },
      ty = {},
      nil_ls = {},
      lua_ls = {
        settings = {
          Lua = {
            format = { enable = false },
            codeLens = { enable = true },
            workspace = { checkThirdParty = false },
          },
        },
      },
      vtsls = {
        settings = {
          vtsls = {
            tsserver = {
              globalPlugins = {
                {
                  name = "@vue/typescript-plugin",
                  location = get_vue_language_server_path(),
                  languages = { "vue" },
                  configNamespace = "typescript",
                },
              },
            },
          },
        },
        filetypes = {
          "typescript",
          "javascript",
          "javascriptreact",
          "typescriptreact",
          "vue",
        },
      },
      vue_ls = {},
    }

    for server, server_opts in pairs(servers) do
      local config = vim.tbl_deep_extend("force", {
        capabilities = capabilities,
      }, server_opts or {})
      vim.lsp.config(server, config)
      vim.lsp.enable(server)
    end
  end,
})
