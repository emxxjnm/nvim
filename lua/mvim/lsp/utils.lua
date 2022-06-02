local M = {}

local bo = vim.bo
local fn = vim.fn
local lsp = vim.lsp
local split = vim.split

local function find(t, func)
  for _, entry in pairs(t) do
    if func(entry) then
      return entry
    end
  end
  return nil
end

-- check if the manager autocmd has alread been configurated
-- since some servers will take a while to initialize.
function M.client_is_configured(name, ft)
  ft = ft or bo.filetype

  local active_autocmds = split(fn.execute("autocmd FileType " .. ft), "\n")

  for _, result in ipairs(active_autocmds) do
    if result:match(name) then
      return true
    end
  end
  return false
end

function M.is_client_active(name)
  local clients = lsp.get_active_clients()

  return find(clients, function(client)
    return client.name == name
  end)
end

return M

