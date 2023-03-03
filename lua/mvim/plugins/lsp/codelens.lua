local M = {}

function M.on_attach(client, buffer)
  if client.server_capabilities["codeLenSProvider"] then
    require("mvim.utils").augroup("LspCodelens." .. buffer, {
      event = { "BufEnter", "CursorHold", "InsertLeave" },
      buffer = buffer,
      desc = "LSP: code lens",
      command = function()
        vim.lsp.codelens.refresh()
      end,
    })
  end
end

return M
