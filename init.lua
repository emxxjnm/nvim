-- require("impatient")

local g = vim.g
g.mapleader = " "
g.maplocalleader = " "

-- Disable some built-in plugins we don't want
local function disabled_builtin_plugins()
  local plugins = {
    "gzip",
    "netrw",
    "netrwPlugin",
    "matchparen",
    "tar",
    "tarPlugin",
    "zip",
    "zipPlugin",
    "matchit",
    "man",
    "2html_plugin",
  }
  for i = 1, #plugins do
    g["loaded_" .. plugins[i]] = 1
  end
end

local function launch()
  disabled_builtin_plugins()

  require("mvim.options")
  require("mvim.keymaps")
  require("mvim.plugins")
  require("mvim.events")
end

launch()
