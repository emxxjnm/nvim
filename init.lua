---------------------------------------------------------------------
--                                                                 --
--   ,--.   ,--.         ,--.                  ,--.   ,--.         --
--   |   `.'   |,--. ,--.|  | ,---.  ,---.     |   `.'   | ,---.   --
--   |  |'.'|  | \  '  / |  || .-. :(  .-'     |  |'.'|  || .-. |  --
--   |  |   |  |  \   '  |  |\   --..-'  `)    |  |   |  |' '-' '  --
--   `--'   `--'.-'  /   `--' `----'`----'     `--'   `--' `---'   --
--              `---'                                              --
--                                                                 --
--              https://github.com/emxxjnm/nvim                    --
---------------------------------------------------------------------

if not pcall(require, "impatient") then
  print("Failed to load impatient.")
end

local g = vim.g

g.mapleader = " "
g.maplocalleader = " "

-- Disable some built-in plugins we don't want
local plugins = {
  "gzip",
  "zip",
  "zipPlugin",
  "tar",
  "tarPlugin",

  "vimball",
  "vimballPlugin",
  "2html_plugin",

  "matchit",
  "matchparen",

  "netrw",
  "netrwPlugin",
  "netrwSettings",
  "tutor_mode_plugin",
}
for i = 1, #plugins do
  g["loaded_" .. plugins[i]] = 1
end

local namespace = {
  style = {},
  config = {
    metadir = ".vim/",
  },
}

_G.mo = mo or namespace

require("mvim.globals")
require("mvim.styles")
require("mvim.plugins")
