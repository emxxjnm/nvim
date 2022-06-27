local M = {}

local fn = vim.fn

local function find_root_dir()
  local util = require("lspconfig.util")
  local lsp_utils = require("mvim.lsp.utils")

  local ts_client = lsp_utils.is_client_active("typescript")

  if ts_client then
    return ts_client.config.root_dir
  end
  local dirname = fn.expand("%:p:h")
  return util.root_pattern(dirname)
end

local function from_node_modules(command)
  local root_dir = find_root_dir()

  if root_dir then
    return nil
  end

  return table.concat({ root_dir, "node_modules", ".bin", command }, "/")
end

local local_providers = {
  eslint_d = { find = from_node_modules },
  eslint = { find = from_node_modules },
  stylelint = { find = from_node_modules },
}

function M.find_command(command)
  if local_providers[command] then
    local local_command = local_providers[command].find(command)
    if local_command and fn.executable(local_command) then
      return local_command
    end
  end

  if command and fn.executable(command) == 1 then
    return command
  end

  return nil
end

function M.list_registered_providers_names(filetype)
  local s = require("null-ls.sources")
  local available_sources = s.get_available(filetype)
  local registered = {}
  for _, source in ipairs(available_sources) do
    for method in pairs(source.methods) do
      registered[method] = registered[method] or {}
      table.insert(registered[method], source.name)
    end
  end
  return registered
end

function M.register_sources(configs, method)
  local null_ls = require("null-ls")
  local is_registered = require("null-ls.sources").is_registered

  local sources, registered_names = {}, {}

  for _, config in ipairs(configs) do
    local cmd = config.exe or config.command
    local name = config.nanme or cmd:gsub("-", "_")
    local type = method == null_ls.methods.CODE_ACTION and "code_actions" or null_ls.methods[method]:lower()
    local source = type and null_ls.builtins[type][name]

    if not source then
      vim.notify("Not a valid source: " .. name, vim.log.levels.ERROR)
    elseif is_registered({ name = source.name or name, method = method }) then
      vim.notify("Source: " .. name .. "had registered.", vim.log.levels.INFO)
    else
      local command = M.find_command(source._opts.command) or source._opts.command

      local compat_opts = vim.deepcopy(config)
      if config.args then
        compat_opts.extra_args = config.args or config.extra_args
        compat_opts.args = nil
      end

      local opts = vim.tbl_deep_extend("keep", { command = command }, compat_opts)
      table.insert(sources, source.with(opts))
      vim.list_extend(registered_names, { source.name })
    end
  end

  if #sources > 0 then
    null_ls.register({ sources = sources })
  end

  return registered_names
end

return M
