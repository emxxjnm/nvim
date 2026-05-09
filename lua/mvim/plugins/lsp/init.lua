local function get_vue_language_server_path()
  local exe = vim.fn.exepath("vue-language-server")
  if exe == "" then return "" end

  local real = vim.uv.fs_realpath(exe) or exe

  local pkg = real:match("(.+/@vue/language%-server)/")
  if pkg then return pkg end

  local prefix = real:match("(.+)/bin/[^/]+$")
  if prefix then
    local p = prefix .. "/lib/language-tools/packages/language-server"
    if vim.uv.fs_stat(p) then return p end
    p = prefix .. "/lib/node_modules/@vue/language-server"
    if vim.uv.fs_stat(p) then return p end
  end

  return ""
end

local M = {
  "neovim/nvim-lspconfig",
  event = { "BufReadPost", "BufNewFile" },
  keys = {
    {
      "<leader>ll",
      function()
        Snacks.win({
          file = vim.lsp.log.get_filename(),
          height = 0.9,
          width = 0.9,
          border = Mo.C.border,
        }):set_title("LSP log", "center")
      end,
      desc = "Lsp Log",
    },
    {
      "<leader>li",
      function()
        Snacks.picker.lsp_config({ configured = true })
      end,
      desc = "Lsp Info",
    },
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
    },
  },
  config = function(_, opts)
    require("mvim.plugins.lsp.diagnostic").setup()

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("SetupLspAutocmd", { clear = true }),
      callback = function(args)
        local buffer = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client then
          require("mvim.plugins.lsp.keymaps").on_attach(client, buffer)
          -- require("mvim.plugins.lsp.codelens").on_attach(client, buffer)
        end
      end,
    })

    for server, server_opts in pairs(opts.servers) do
      local config = vim.tbl_deep_extend("force", {
        workspace = {
          fileOperations = {
            didRename = true,
            willRename = true,
          },
        },
      }, vim.lsp.protocol.make_client_capabilities(), server_opts or {})

      vim.lsp.config(server, config)

      if not vim.lsp.is_enabled(server) then
        vim.schedule(function()
          vim.lsp.enable(server)
        end)
      end
    end
  end,
}

return M
