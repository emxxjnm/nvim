vim.loader.enable()

---@class Mo
---@field C mvim.config
Mo = {}

function Mo.once(fn)
  local done = false
  return function(...)
    if done then
      return
    end
    done = true
    return fn(...)
  end
end

Mo.C = require("mvim.config")

require("mvim.options")

for _, p in ipairs({
  "netrw",
  "netrwPlugin",
  "gzip",
  "tarPlugin",
  "zipPlugin",
  "matchit",
  "matchparen",
  "tohtml",
  "spellfile_plugin",
  "tutor_mode_plugin",
  "remote_plugins",
}) do
  vim.g["loaded_" .. p] = 1
end

-- PackChanged hooks (must be registered before any vim.pack.add)
vim.api.nvim_create_autocmd("User", {
  pattern = "PackChanged",
  callback = function(args)
    local data = args.data
    local name = data.name
    local kind = data.kind

    if name == "nvim-treesitter" and (kind == "install" or kind == "update") then
      vim.cmd("TSUpdate")
    elseif name == "blink.cmp" and (kind == "install" or kind == "update") then
      require("blink.cmp").download():wait(60000)
    end
  end,
})
