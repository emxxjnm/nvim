local utils = require("mvim.plugins.lsp.utils")

local api, lsp = vim.api, vim.lsp

api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local client = lsp.get_client_by_id(args.data.client_id)
    local augroup = utils.augroup_factory(client, bufnr)

    augroup(utils.FEATURES.CODELENS, function()
      return {
        {
          event = { "BufEnter", "CUrsorHold", "InsertLeave" },
          buffer = bufnr,
          desc = "LSP: code lens",
          command = function()
            lsp.codelens.refresh()
          end,
        },
      }
    end)
  end,
})
