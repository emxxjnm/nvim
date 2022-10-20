local M = {}

local fmt = string.format
local levels = vim.log.levels

local lsp_utils = require("mvim.lsp.utils")
local server_mapping = require("mason-lspconfig.mappings.server")

local function resolve_mason_config(name)
  local found, config =
    mo.require(fmt("mason-lspconfig.server_configurations.%s", name), { silent = true })
  if not found then
    return {}
  end

  local path = require("mason-core.path")
  local pkg_name = server_mapping.lspconfig_to_package[name]
  local install_dir = path.package_prefix(pkg_name)
  local conf = config(install_dir)

  return conf
end

-- resolve the configuration
local function resolve_config(name, ...)
  local defaults = require("mvim.lsp.config").get_common_opts()

  local has_provider, cfg = mo.require(fmt("mvim.lsp.providers.%s", name), { silent = true })
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
  mo.wrap_error(fmt("failed to setup LSP %s", name), function()
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

  if lsp_utils.is_client_active(name) or lsp_utils.client_is_configured(name) then
    return
  end

  local registry = require("mason-registry")

  local pkg_name = server_mapping.lspconfig_to_package[name]
  if not pkg_name then
    return
  end

  if not registry.is_installed(pkg_name) then
    vim.notify_once(
      fmt("Installation in progress for [%s]", name),
      levels.INFO,
      { title = "LSP Setup" }
    )
    local pkg = registry.get_package(pkg_name)
    pkg:install():once(
      "closed",
      vim.schedule_wrap(function()
        if pkg:is_installed() then
          vim.notify_once(
            fmt("Installation complete for [%s]", name),
            levels.INFO,
            { title = "LSP Setup" }
          )
          local conf = resolve_config(name, resolve_mason_config(name), config)
          launch_server(name, conf)
        end
      end)
    )
    return
  end

  local conf = resolve_config(name, resolve_mason_config(name), config)
  launch_server(name, conf)
end

return M
