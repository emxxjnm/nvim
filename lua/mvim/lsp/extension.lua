local M = {}

function M.setup()
  local null_ls = require("null-ls")
  local default_opts = require("mvim.lsp").get_opts()
  local opts = vim.tbl_deep_extend("force", default_opts, {})
  null_ls.setup(opts)
end

return M
