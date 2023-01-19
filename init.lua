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

local g, fn = vim.g, vim.fn

g.mapleader = " "
g.maplocalleader = " "

local namespace = {
  styles = {},
  settings = {
    metadir = ".vim",
    swapdir = fn.stdpath("cache") .. "/swap",
    undodir = fn.stdpath("cache") .. "/undo",
    backupdir = fn.stdpath("cache") .. "/backup",
  },
}

_G.mo = mo or namespace

require("mvim.config").setup()
