local M = {}

local U = require("mvim.utils")

function M.on_attach(client, buffer)
  if client.server_capabilities[U.lsp_providers.FORMATTING] then
    U.augroup(("LspFormatting.%d"):format(buffer), {
      event = "BufWritePre",
      buffer = buffer,
      command = function(args)
        vim.lsp.buf.format({
          bufnr = args.buf,
          async = false,
          filter = function(c)
            local disabled_ls = { "volar" }
            return not vim.tbl_contains(disabled_ls, c.name)
          end,
        })
      end,
      desc = "LSP: Format on save",
    })
  end
end

return M
