local utils = require("mvim.plugins.lsp.utils")

local api, lsp = vim.api, vim.lsp

local function highlight_references()
  local status_ok, ts_utils = pcall(function()
    return require("nvim-treesitter.ts_utils")
  end)
  if status_ok then
    local node = ts_utils.get_node_at_cursor()
    while node ~= nil do
      local node_type = node:type()
      if
        node_type == "string"
        or node_type == "string_fragment"
        or node_type == "template_string"
        or node_type == "document"
      then
        return
      end
      node = node:parent()
    end
  end
  vim.lsp.buf.document_highlight()
end

api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local client = lsp.get_client_by_id(args.data.client_id)
    local augroup = utils.augroup_factory(client, bufnr)

    augroup(utils.FEATURES.HIGHLIGHT, function()
      return {
        {
          event = { "CursorHold", "CursorHoldI" },
          buffer = bufnr,
          desc = "LSP: References",
          command = highlight_references,
        },
        {
          event = "CursorMoved",
          desc = "LSP: References Clear",
          buffer = bufnr,
          command = function()
            lsp.buf.clear_references()
          end,
        },
      }
    end)
  end,
})
