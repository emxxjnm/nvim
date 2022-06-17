-- if not pcall(require, "impatient") then
--   print("Failed to load impatient.")
-- end

vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable some built-in plugins we don't want
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
  vim.g["loaded_" .. plugins[i]] = 1
end

require("mvim.plugins")
