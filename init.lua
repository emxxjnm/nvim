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

g.do_filetype_lua = 1
g.did_load_filetypes = 0

g.mapleader = " "
g.maplocalleader = " "

-- Disable some built-in plugins we don't want
local plugins = {
  "gzip",
  "zip",
  "zipPlugin",
  "tar",
  "tarPlugin",

  "getscript",
  "getscriptPlugin",
  "vimball",
  "vimballPlugin",
  "2html_plugin",

  "matchit",
  "matchparen",
  "logiPat",
  "rrhelper",

  "netrw",
  "netrwPlugin",
  "netrwSettings",

  "man",
  "tutor_mode_plugin",
}
for i = 1, #plugins do
  g["loaded_" .. plugins[i]] = 1
end

require("mvim.plugins")
