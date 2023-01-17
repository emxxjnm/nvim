local utils = require("mvim.plugins.lsp.utils")

local fmt = string.format
local icons = mo.style.icons.diagnostics
local fn, api, lsp, diagnostic = vim.fn, vim.api, vim.lsp, vim.diagnostic

-- Diagnostic configuration
diagnostic.config({
  signs = true,
  underline = true,
  severity_sort = true,
  update_in_insert = false,
  virtual_text = false,
  float = {
    header = "",
    border = mo.style.border.current,
    source = true,
    focusable = false,
    prefix = function(d, i)
      local level = diagnostic.severity[d.severity]
      local prefix = fmt("%d. %s ", i, icons[level:lower()])
      return prefix, "DiagnosticFloating" .. level
    end,
  },
})

for name, icon in pairs(icons) do
  name = "DiagnosticSign" .. name:gsub("^%l", string.upper)
  fn.sign_define(name, { text = icon, texthl = name })
end

api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local client = lsp.get_client_by_id(args.data.client_id)
    local augroup = utils.augroup_factory(client, bufnr)

    augroup(utils.FEATURES.DIAGNOSTICS, function()
      return {
        {
          event = "CursorHold",
          buffer = bufnr,
          desc = "LSP: show diagnostics",
          command = function(params)
            vim.diagnostic.open_float(params.buf, { scope = "cursor", focus = false })
          end,
        },
      }
    end)
  end,
})
