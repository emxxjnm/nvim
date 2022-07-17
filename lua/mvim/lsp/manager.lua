local M = {}

local lsp_utils = require("mvim.lsp.utils")

-- resolve the configuration
local function resolve_config(name, ...)
  local defaults = require("mvim.lsp.config").get_common_opts()

  local has_provider, cfg = pcall(require, "mvim.lsp.providers." .. name)
  if has_provider then
    defaults = vim.tbl_deep_extend("force", defaults, cfg) or {}
  end

  defaults = vim.tbl_deep_extend("force", defaults, ...) or {}

  return defaults
end

local function buf_try_add(name, bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  require("lspconfig")[name].manager.try_add_wrapper(bufnr)
end

local function launch_server(name, cfg)
  pcall(function()
    require("lspconfig")[name].setup(cfg)
    buf_try_add(name)
  end)
end

---lsp setup entry
---@param name string lsp name
---@param config table? lsp config
function M.setup(name, config)
  vim.validate({ name = { name, "string" } })
  config = config or {}

  if lsp_utils.is_client_active(name) then
    return
  end

  local servers = require("nvim-lsp-installer.servers")
  local available, server = servers.get_server(name)

  if not available then
    local conf = resolve_config(name, config)
    launch_server(name, conf)
    return
  end

  if not server:is_installed() then
    server:install()
  end

  server:on_ready(function()
    local conf = resolve_config(name, server:get_default_options(), config)
    launch_server(name, conf)
  end)
end

return M
