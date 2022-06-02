local M = {}

local null_ls = require("null-ls")
local services = require("mvim.lsp.extension.services")

local tbl_isempty = vim.tbl_isempty
local method = null_ls.method.CODE_ACTION

function M.list_registered(filetype)
  local providers = services.list_registered_providers_names(filetype)
  return providers[method] or {}
end

function M.setup(configs)
  if tbl_isempty(configs) then
    return
  end

  services.register_sources(configs, method)
end

return M
