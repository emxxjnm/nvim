local utils = require("mvim.plugins.lsp.utils")

local fmt = string.format
local icons = mo.styles.icons.diagnostics
local fn, api, lsp = vim.fn, vim.api, vim.lsp

-- Diagnostic configuration
vim.diagnostic.config({
  severity_sort = true,
  virtual_text = false,
  float = {
    header = "",
    source = false,
    border = mo.styles.border,
    prefix = function(d)
      local level = vim.diagnostic.severity[d.severity]
      local prefix = fmt("%s ", icons[level:lower()])
      return prefix, "DiagnosticFloating" .. level
    end,
    format = function(d)
      local source = string.gsub(d.source, "%.$", "")
      return fmt("%s: %s", source, d.message)
    end,
    suffix = function(d)
      local code = d.code or (d.user_data and d.user_data.lsp.code)
      local suffix = code and fmt(" (%s)", code) or ""
      return suffix, "Comment"
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
