local fmt = string.format

local M = {}

function M.setup_diagnostics()
  local icons = Mo.C.icons.diagnostics
  vim.diagnostic.config({
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = icons.error,
        [vim.diagnostic.severity.WARN] = icons.warn,
        [vim.diagnostic.severity.HINT] = icons.hint,
        [vim.diagnostic.severity.INFO] = icons.info,
      },
    },
    severity_sort = true,
    virtual_text = {
      source = false,
      spacing = 2,
      prefix = "●",
    },
    float = {
      header = "",
      source = false,
      border = Mo.C.border,
      prefix = function(d)
        local level = vim.diagnostic.severity[d.severity]
        local prefix = icons[level:lower()]
        return prefix, "DiagnosticFloating" .. level
      end,
      format = function(d)
        return d.source and fmt("%s: %s", string.gsub(d.source, "%.$", ""), d.message) or d.message
      end,
      suffix = function(d)
        local code = d.code or (d.user_data and d.user_data.lsp and d.user_data.lsp.code)
        local suffix = code and fmt(" (%s)", code) or ""
        return suffix, "Comment"
      end,
    },
  })
end

-- stylua: ignore
local keys = {
  { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
  { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition"  },
  { "gt", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto Type Definition" },

  { "grr", function() Snacks.picker.lsp_references() end, desc = "References" },
  { "gri", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },

  { "<leader>cc", vim.lsp.codelens.run, desc = "Codelens", mode = { "n", "v" } },
  { "<leader>cC", vim.lsp.codelens.refresh, desc = "Codelens" },

  { "<leader>fs", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
  { "<leader>fS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
}

---@param client vim.lsp.Client
---@param buffer number
function M.on_attach(client, buffer)
  if vim.b[buffer].lsp_keymaps_set then
    return
  end
  vim.b[buffer].lsp_keymaps_set = true
  vim.iter(keys):each(function(m)
    local opts = { silent = true, buffer = buffer, desc = m.desc }
    vim.keymap.set(m.mode or "n", m[1], m[2], opts)
  end)
end

return M
