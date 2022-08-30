local M = {}

local fn = vim.fn
local lsp = vim.lsp
local fmt = string.format

---This function allows reading a per project `settings.josn` file
---in the `.vim` directory of the project
---@param client table<string, any> lsp client
---@return boolean
function M.common_on_init(client)
  local settings = client.workspace_folders[1].name .. "/.vim/settings.json"
  if fn.filereadable(settings) == 0 then
    return true
  end
  local ok, json = pcall(fn.readfile, settings)
  if not ok then
    return true
  end
  local overrides = vim.json.decode(table.concat(json, "\n"))
  for name, config in pairs(overrides) do
    if name == client.name then
      client.config = vim.tbl_deep_extend("force", client.config, config)
      client.notify("workspace/didChangeConfiguration")
      vim.schedule(function()
        local path = fn.fnamemodify(settings, ":~:.")
        local msg = fmt("loaded local settings for %s from %s", client.name, path)
        vim.notify_once(msg, "info", { title = "LSP Settings" })
      end)
    end
  end
  return true
end

function M.common_on_exit() end

function M.common_capabilities()
  local capabilities = lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }

  local ok, cmp_nvim_lsp = mo.require("cmp_nvim_lsp")
  if ok then
    capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
  end

  return capabilities
end

---@return table
function M.get_common_opts()
  return {
    on_init = M.common_on_init,
    on_exit = M.common_on_exit,
    capabilities = M.common_capabilities(),
  }
end

return M
