local utils = require("mvim.plugins.lsp.utils")

local api, lsp = vim.api, vim.lsp

api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local client = lsp.get_client_by_id(args.data.client_id)
    local augroup = utils.augroup_factory(client, bufnr)

    augroup(utils.FEATURES.FORMATTING, function()
      return {
        {
          event = "BufWritePre",
          buffer = bufnr,
          desc = "LSP: Format on save",
          command = function(params)
            utils.format({ bufnr = params.buf })
          end,
        },
      }
    end)
  end,
})
