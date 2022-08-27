local api = vim.api
local fmt = string.format

-------------------------------------------------------------------------------
-- Augroup
-------------------------------------------------------------------------------
---@class AutocmdArgs
---@field id number
---@field event string
---@field group string?
---@field buf number
---@field file string
---@field match string | number
---@field data any

---@class Autocommand
---@field desc string
---@field event  string | string[] autocommand events
---@field pattern string | string[] autocommand patterns
---@field command string | fun(args: AutocmdArgs): boolean?
---@field nested  boolean
---@field once    boolean
---@field buffer  number

---Create an autocommand
---returns the group ID so that it can be cleared or maipulated.
---@param name string
---@param commands Autocommand[]
---@return number augroup id
function mo.augroup(name, commands)
  assert(name ~= "User", "The name of an augroup CANNOT be User")
  assert(#commands > 0, fmt("You must specify at least on autocommand for %s", name))
  local group_id = api.nvim_create_augroup(name, { clear = true })
  for _, autocmd in ipairs(commands) do
    local is_callback = type(autocmd.command) == "function"
    api.nvim_create_autocmd(autocmd.event, {
      group = group_id,
      pattern = autocmd.pattern,
      desc = autocmd.desc,
      callback = is_callback and autocmd.command or nil,
      command = not is_callback and autocmd.command or nil,
      once = autocmd.once,
      nested = autocmd.nested,
      buffer = autocmd.buffer,
    })
  end
  return group_id
end

---Clean autocommand in a group if it exists
---This is safer than trying to delete the augroup itself
--@param name string augroup name
function mo.clear_augroup(name)
  -- defer the function in case the autocommand is still in-use
  local exists, _ = pcall(api.nvim_get_autocmds, { group = name })
  if not exists then
    return
  end

  vim.schedule(function()
    local status_ok, _ = xpcall(function()
      api.nvim_clear_autocmds({ group = name })
    end, debug.traceback)
    if not status_ok then
      vim.notify("problems detected while clearing autocmds from " .. name)
    end
  end)
end

---Require a module using `pcall` and report any error
---@param module string
---@param opts table?
---@return boolean, any
function mo.require(module, opts)
  opts = opts or { slient = false }
  local ok, result = pcall(require, module)
  if not ok and not opts.silent then
    if opts.message then
      result = opts.message .. "\n" .. result
    end
    vim.notify(result, vim.log.levels.ERROR, { title = fmt("Error requiring %s", module) })
  end
  return ok, result
end
