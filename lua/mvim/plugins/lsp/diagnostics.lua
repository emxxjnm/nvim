local fmt = string.format

local M = {}

function M.setup()
  for name, icon in pairs(I.diagnostics) do
    name = "DiagnosticSign" .. name:gsub("^%l", string.upper)
    vim.fn.sign_define(name, { text = icon, texthl = name })
  end

  vim.diagnostic.config({
    severity_sort = true,
    virtual_text = {
      source = false,
      severity = vim.diagnostic.severity.ERROR,
      spacing = 1,
      format = function(d)
        local level = vim.diagnostic.severity[d.severity]
        return fmt("%s %s", I.diagnostics[level:lower()], d.message)
      end,
    },
    float = {
      header = "",
      source = false,
      border = mo.styles.border,
      prefix = function(d)
        local level = vim.diagnostic.severity[d.severity]
        local prefix = fmt("%s ", I.diagnostics[level:lower()])
        return prefix, "DiagnosticFloating" .. level
      end,
      format = function(d)
        return d.source and fmt("%s: %s", string.gsub(d.source, "%.$", ""), d.message) or d.message
      end,
      suffix = function(d)
        local code = d.code or (d.user_data and d.user_data.lsp.code)
        local suffix = code and fmt(" (%s)", code) or ""
        return suffix, "Comment"
      end,
    },
  })

  require("mvim.utils").augroup("LspDiagnostics", {
    event = "CursorHold",
    desc = "LSP: show diagnostics",
    command = function()
      vim.diagnostic.open_float({ scope = "cursor", focus = false })
    end,
  })
end

return M
