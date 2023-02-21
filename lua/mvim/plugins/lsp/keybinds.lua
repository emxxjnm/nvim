local M = {}

---@type PluginLspKeys
M._keys = nil

---@return (LazyKeys|{has?:string})[]
function M.get()
  local format = require("mvim.plugins.lsp.format").format

  ---@class PluginLspKeys
  M._keys = M._keys
    or {
      { "gd", "<cmd>Telescope lsp_definitions<cr>", desc = "Goto Definition" },
      { "gr", "<cmd>Telescope lsp_references<cr>", desc = "References" },
      { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
      { "gi", "<cmd>Telescope lsp_implementations<cr>", desc = "Goto Implementation" },
      { "gt", "<cmd>Telescope lsp_type_definitions<cr>", desc = "Goto Type Definition" },

      { "K", vim.lsp.buf.hover, desc = "Hover" },
      { "gK", vim.lsp.buf.signature_help, desc = "Signature Help", has = "signatureHelp" },
      {
        "<C-k>",
        vim.lsp.buf.signature_help,
        mode = "i",
        desc = "Signature Help",
        has = "signatureHelp",
      },

      { "[d", vim.diagnostic.goto_prev, desc = "Prev Diagnostic" },
      { "]d", vim.diagnostic.goto_next, desc = "Next Diagnostic" },

      { "<leader>cf", format, desc = "Format Document", has = "documentFormatting" },
      { "<leader>cf", format, desc = "Format Range", mode = "v", has = "documentRangeFormatting" },
      { "<leader>cr", vim.lsp.buf.rename, expr = true, desc = "Rename", has = "rename" },
      {
        "<leader>ca",
        vim.lsp.buf.code_action,
        desc = "Code Action",
        mode = { "n", "v" },
        has = "codeAction",
      },

      { "<leader>cl", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
    }
  return M._keys
end

function M.on_attach(client, buffer)
  local Keys = require("lazy.core.handler.keys")
  local keymaps = {} ---@type table<string,LazyKeys|{has?:string}>

  for _, value in ipairs(M.get()) do
    local keys = Keys.parse(value)
    if keys[2] == vim.NIL or keys[2] == false then
      keymaps[keys.id] = nil
    else
      keymaps[keys.id] = keys
    end
  end

  for _, keys in pairs(keymaps) do
    if not keys.has or client.server_capabilities[keys.has .. "Provider"] then
      local opts = Keys.opts(keys)
      opts.has = nil
      opts.silent = true
      opts.buffer = buffer
      vim.keymap.set(keys.mode or "n", keys[1], keys[2], opts)
    end
  end
end

return M
