local M = {}

local U = require("mvim.utils")

function M.on_attach(client, buffer)
  if client.server_capabilities[U.lsp_providers.CODELENS] then
    U.augroup(("LspCodelens.%d"):format(buffer), {
      event = { "BufEnter", "BufWritePost", "InsertLeave" },
      buffer = buffer,
      desc = "LSP: code lens",
      command = function()
        vim.lsp.codelens.refresh()
      end,
    })
  end
end

return M
