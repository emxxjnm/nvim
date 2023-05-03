local M = {}

-- handler overrides
local ns = vim.api.nvim_create_namespace("severe-diagnostics")

--- Restricts nvim's diagnostic signs to only the single most severe one per line
function M.max_diagnostic(callback)
  return function(_, bufnr, _, opts)
    -- Get all diagnostics from the whole buffer rather than just the
    -- diagnostics passed to the handler
    local diagnostics = vim.diagnostic.get(bufnr)

    -- Find the "worst" diagnostic per line
    local max_severity_per_line = {}
    for _, d in pairs(diagnostics) do
      local m = max_severity_per_line[d.lnum]
      if not m or d.severity < m.severity then
        max_severity_per_line[d.lnum] = d
      end
    end

    -- Pass the filtered diagnostics (with our custom namespace)
    -- to the original handler
    callback(ns, bufnr, vim.tbl_values(max_severity_per_line), opts)
  end
end

local signs_handler = vim.diagnostic.handlers.signs

local virt_text_handler = vim.diagnostic.handlers.virtual_text

function M.setup()
  require("lspconfig.ui.windows").default_options.border = "rounded"

  vim.lsp.handlers["textDocument/hover"] =
    vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

  vim.diagnostic.handlers.signs = vim.tbl_extend("force", signs_handler, {
    show = M.max_diagnostic(signs_handler.show),
    hide = function(_, bufnr)
      signs_handler.hide(ns, bufnr)
    end,
  })

  vim.diagnostic.handlers.virtual_text = vim.tbl_extend("force", virt_text_handler, {
    show = M.max_diagnostic(virt_text_handler.show),
    hide = function(_, bufnr)
      virt_text_handler.hide(ns, bufnr)
    end,
  })
end

return M
