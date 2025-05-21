local M = {}

-- stylua: ignore
M.keys = {
  { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration", deps = "textDocument/declaration" },
  { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition", deps = "textDocument/definition" },
  { "gr", function() Snacks.picker.lsp_references() end, desc = "References", deps = "textDocument/references" },
  { "gi", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation", deps = "textDocument/implementation" },
  { "gt", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto Type Definition", deps = "textDocument/definition" },

  { "K", vim.lsp.buf.hover, desc = "Hover", deps = "textDocument/hover" },
  { "gK", vim.lsp.buf.signature_help, desc = "Signature Help", deps = "textDocument/signatureHelp" },
  { "<C-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help", deps = "textDocument/signatureHelp" },

  { "<leader>cr", vim.lsp.buf.rename, desc = "Rename", deps = "textDocument/rename"  },
  { "<leader>ca", vim.lsp.buf.code_action, desc = "Code action", mode = { "n", "v" }, deps = "textDocument/codeAction" },
  { "<leader>cA", function() vim.lsp.buf.code_action({ apply = true, context = { only = { "source" }, diagnostics = {}}}) end, desc = "Source Action", desp = "textDocument/codeAction" },

  { "<leader>cc", vim.lsp.codelens.run, desc = "Codelens", mode = { "n", "v" }, deps = "textDocument/codeLens" },
  { "<leader>cC", vim.lsp.codelens.refresh, desc = "Codelens", deps = "textDocument/codeLens" },

  -- TODO: add filter
  { "<leader>fs", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols", deps = "textDocument/documentSymbol" },
  { "<leader>fS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols", deps = "workspace/symbols" },
}

---@param client vim.lsp.Client
---@param buffer number
function M.on_attach(client, buffer)
  vim.iter(M.keys):each(function(m)
    if not m.deps or client:supports_method(m.deps) then
      local opts = { silent = true, buffer = buffer, desc = m.desc }
      vim.keymap.set(m.mode or "n", m[1], m[2], opts)
    end
  end)
end

return M
