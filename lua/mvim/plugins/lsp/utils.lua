local M = {}

local ok, null_ls = pcall(require, "null-ls")
if not ok then
  return
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

---check if the manager autocmd has already been configured
---since some servers can take a while to initialize
---@param name string lsp client name
---@param ft string? filetype
---@return boolean
function M.client_is_configured(name, ft)
  ft = ft or vim.bo.filetype
  local active_autocmds = vim.api.nvim_get_autocmds({ event = "FileType", pattern = ft })
  for _, result in ipairs(active_autocmds) do
    if result.desc ~= nil and result.desc:match("server " .. name .. " ") then
      return true
    end
  end
  return false
end

---list providers
---@param filetype string filetype
---@return table providers null-ls providers
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
  local method = null_ls.methods.FORMATTING
  local providers = M.list_registered_providers_names(filetype)
  return providers[method] or {}
end

local alternative_methods = {
  null_ls.methods.DIAGNOSTICS,
  null_ls.methods.DIAGNOSTICS_ON_OPEN,
  null_ls.methods.DIAGNOSTICS_ON_SAVE,
}

---list registered linters
---@param filetype string filetype
---@return string[] providers name of the providers
function M.list_registered_linters(filetype)
  local providers = M.list_registered_providers_names(filetype)
  local names = vim.tbl_flatten(vim.tbl_map(function(m)
    return providers[m] or {}
  end, alternative_methods))
  return names
end

function M.formatter_filter(client)
  local exclude = ({
    lua = { "sumneko_lua" },
    typescript = { "tsserver" },
    vue = { "volar" },
  })[vim.bo.filetype]

  if not exclude then
    return true
  end
  return not vim.tbl_contains(exclude, client.name)
end

---@param opts? table<string, any>
function M.format(opts)
  opts = opts or {}
  vim.lsp.buf.format({
    bufnr = opts.bufnr,
    async = opts.async,
    filter = M.formatter_filter,
  })
end

M.FEATURES = {
  DIAGNOSTICS = { name = "diagnostics" },
  CODELENS = { name = "codelens", provider = "codeLenSProvider" },
  HIGHLIGHT = { name = "highlight", provider = "documentHighlightProvider" },
  FORMATTING = { name = "formatting", provider = "documentFormattingProvider" },
}

--- Create augroups for each LSP feature and track
--- which capabilities each client registers in a buffer
---@param bufnr integer
---@param client table
---@return fun(feature: table, commands: fun(provider: string): Autocommand[])
function M.augroup_factory(client, bufnr)
  return function(feature, commands)
    local provider, name = feature.provider, feature.name
    if not provider or client.server_capabilities[provider] then
      mo.augroup(string.format("LspCommands_%d_%s", bufnr, name), commands(provider))
    end
  end
end

return M
