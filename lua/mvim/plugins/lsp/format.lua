local M = {}

local U = require("mvim.utils")

M.opts = {
  autoformat = true,
}

function M.toggle()
  M.opts.autoformat = not M.opts.autoformat
  if M.opts.autoformat then
    vim.notify("Enable format on save")
  else
    vim.notify("Disabled format on save", vim.log.levels.WARN)
  end
end

function M.on_attach(client, buffer)
  if client.server_capabilities[U.lsp_providers.FORMATTING] then
    U.augroup(("LspFormatting.%d"):format(buffer), {
      event = "BufWritePre",
      buffer = buffer,
      command = function(args)
        if M.opts.autoformat then
          vim.lsp.buf.format({
            bufnr = args.buf,
            async = false,
            filter = function(c)
              local disabled_ls = { "volar" }
              return not vim.tbl_contains(disabled_ls, c.name)
            end,
          })
        end
      end,
      desc = "LSP: Format on save",
    })
  end
end

return M
