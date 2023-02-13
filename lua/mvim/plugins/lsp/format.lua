local M = {}

function M.filter(client)
  local exclude = ({
    lua = { "lua_ls" },
    typescript = { "tsserver" },
    vue = { "volar" },
  })[vim.bo.filetype]

  if not exclude then
    return true
  end
  return not vim.tbl_contains(exclude, client.name)
end

function M.format(opts)
  opts = opts or {}
  vim.lsp.buf.format({
    bufnr = opts.bufnr,
    async = opts.async,
    filter = M.filter,
  })
end

function M.on_attach(client, buffer)
  if client.server_capabilities["documentFormattingProvider"] then
    require("mvim.utils").augroup("LspFormat." .. buffer, {
      {
        event = "BufWritePre",
        buffer = buffer,
        command = function(args)
          M.format({ bufnr = args.buf, async = false })
        end,
        desc = "LSP: Format on save",
      },
    })
  end
end

return M
