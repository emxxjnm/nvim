local M = {}

function M.on_attach(client, buffer)
  if client.supports_method(U.lsp.providers.CODELENS) then
    require("mvim.util").augroup(("LspCodelens.%d"):format(buffer), {
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
