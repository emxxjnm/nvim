local M = {}

local fn = vim.fn
local lsp = vim.lsp
local deepcopy = vim.deepcopy
local diagnostic = vim.diagnostic

function M.setup()

  local signs = {
    { name = "DiagnosticSignError", text = "", numhl = "RedSign" },
    { name = "DiagnosticSignWarn", text = "", numhl = "YellowSign" },
    { name = "DiagnosticSignHint", text = "", numhl = "BlueSign" },
    { name = "DiagnosticSignInfo", text = "", numhl = "WhiteSign" },
  }

  for _, sign in ipairs(signs) do
    fn.sign_define(
      sign.name,
      {
        texthl = sign.name,
        text = sign.text,
        numhl = sign.numhl,
      }
    )
  end

  local config = {
    virtual_text = true,
    signs = {
      active = signs,
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
      format = function(d)
        local t = deepcopy(d)
        local code = d.code or (d.user_data and d.user_data.lsp.code)
        if code then
          t.message = string.format("%s [%s]", t.message, code):gsub("1. ", "")
        end
        return t.message
      end,
    }
  }

  diagnostic.config(config)

  lsp.handlers["textDocument/hover"] = lsp.with(
    lsp.handlers.hover,
    {
      border = "rounded",
    }
  )
  lsp.handlers["textDocument/signatureHelp"] = lsp.with(
    lsp.handlers.signature_help,
    {
      border = "rounded",
    }
  )
  lsp.handlers["temxtDocument/publishDiagnostics"] = lsp.with(
    lsp.handlers.diagnostic,
    {
      virtual_text = true,
      signs = true,
      update_in_insert = false,
      underline = true,
    }
  )
end

return M
