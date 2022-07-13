local M = {}

---register the null-ls sources
---@param configs table null-ls config
---@param method string null-ls method
function M.register(configs, method)
  local null_ls = require("null-ls")
  local is_registered = require("null-ls.sources").is_registered

  local sources = {}

  for _, config in ipairs(configs) do
    local cmd = config.exe or config.command
    local name = config.nanme or cmd:gsub("-", "_")
    local type = method == null_ls.methods.CODE_ACTION and "code_actions" or null_ls.methods[method]:lower()
    local source = type and null_ls.builtins[type][name]

    if source and not is_registered({ name = source.name or name, method = method }) then
      local command = source._opts.command
      local compat_opts = vim.deepcopy(config)
      if config.args then
        compat_opts.extra_args = config.args or config.extra_args
        compat_opts.args = nil
      end
      local opts = vim.tbl_deep_extend("keep", { command = command }, compat_opts)
      table.insert(sources, source.with(opts))
    end
  end

  if #sources > 0 then
    null_ls.register({ sources = sources })
  end
end

return M
