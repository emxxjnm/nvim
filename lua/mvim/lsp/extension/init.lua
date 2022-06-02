local M = {}

local tbl_deep_extend = vim.tbl_deep_extend

function M.setup()
  local status_ok, null_ls = pcall(require, "null-ls")
  if not status_ok then
    return
  end
  local default_opts = require("mvim.lsp").get_opts()

  null_ls.setup(tbl_deep_extend("force", default_opts, {}))
end

return M
