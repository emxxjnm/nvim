local M = {}

local providers = require("mvim.util").lsp.providers

M._keys = nil

function M.get()
  if not M._keys then
    -- stylua: ignore
    M._keys = {
      { "gd", "<CMD>Telescope lsp_definitions<CR>", desc = "Goto Definition", depends = providers.DEFINITION },
      { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration", depends = providers.DECLARATION },
      { "gr", "<CMD>Telescope lsp_references<CR>", desc = "References", depends = providers.REFERENCES },
      { "gi", "<CMD>Telescope lsp_implementations<CR>", desc = "Goto Implementation", depends = providers.IMPLEMENTATION },
      { "gt", "<CMD>Telescope lsp_type_definitions<CR>", desc = "Goto Type Definition", depends = providers.DEFINITION },
      { "K", vim.lsp.buf.hover, desc = "Hover", depends = providers.HOVER },
      { "gK", vim.lsp.buf.signature_help, desc = "Signature Help", depends = providers.SIGNATUREHELP },
      { "<C-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help", depends = providers.SIGNATUREHELP },
      { "<leader>cr", vim.lsp.buf.rename, desc = "Rename", depends = providers.RENAME },
      { "<leader>ca", vim.lsp.buf.code_action, desc = "Code action", mode = { "n", "v" }, depends = providers.CODEACTION },
    }
  end
  return M._keys
end

function M.on_attach(client, buffer)
  local Keys = require("lazy.core.handler.keys")
  local keymaps = Keys.resolve(M.get())

  for _, keys in pairs(keymaps) do
    if not keys.depends or client.supports_method(keys.depends) then
      local opts = Keys.opts(keys)
      opts.depends = nil
      opts.silent = opts.silent ~= false
      opts.buffer = buffer
      vim.keymap.set(keys.mode or "n", keys.lhs, keys.rhs, opts)
    end
  end

  -- vim.iter(M.get()):each(function(m)
  --   if not m.depends or client.supports_method(m.depends) then
  --     local opts = Keys.opts(m)
  --     opts.depends = nil
  --     opts.silent = opts.silent ~= false
  --     opts.buffer = buffer
  --     vim.keymap.set(m.mode or "n", m[1], m[2], opts)
  --   end
  -- end)
end

return M
