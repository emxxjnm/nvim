local M = {}

---@param fun function
---@return fun() @function that calls the provided fun, but with no args
function M.fn(fun)
  return function()
    return fun()
  end
end

---@param t table table
local function find(t, func)
  for _, entry in pairs(t) do
    if func(entry) then
      return entry
    end
  end
  return nil
end

---@param name string client name
function M.is_client_active(name)
  local clients = vim.lsp.get_active_clients()

  return find(clients, function(client)
    return client.name == name
  end)
end

---list providers
---@param filetype string filetype
---@return string[] providers null-ls providers
function M.list_registered_providers_names(filetype)
  local sources = require("null-ls.sources")
  local available_sources = sources.get_available(filetype)
  local registered = {}
  for _, source in ipairs(available_sources) do
    for method in pairs(source.methods) do
      registered[method] = registered[method] or {}
      table.insert(registered[method], source.name)
    end
  end
  return registered
end

---list registered formatters
---@param filetype string filetype
---@return string[] providers name of the providers
function M.list_registered_formatters(filetype)
  local methods = require("null-ls.methods")
  local method = methods.internal["FORMATTING"]
  local providers = M.list_registered_providers_names(filetype)
  return providers[method] or {}
end

---list registered linters
---@param filetype string filetype
---@return string[] providers name of the providers
function M.list_registered_linters(filetype)
  local methods = require("null-ls.methods")
  local method = methods.internal["DIAGNOSTICS"]
  local providers = M.list_registered_providers_names(filetype)
  return providers[method] or {}
end

return M
