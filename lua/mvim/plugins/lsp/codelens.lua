local M = {}

local U = require("mvim.util")

function M.on_attach(client, buffer)
  if client.supports_method(U.lsp.providers.CODELENS) then
    U.augroup(("LspCodelens.%d"):format(buffer), {
      event = { "BufEnter", "CursorHold", "InsertLeave" },
      buffer = buffer,
      desc = "LSP: code lens",
      command = vim.lsp.codelens.refresh,
    })
  end
end

return M
