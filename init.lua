local namespace = {
  styles = {},
  settings = {
    metadir = ".vscode",
    swapdir = vim.fn.stdpath("cache") .. "/swap",
    undodir = vim.fn.stdpath("cache") .. "/undo",
    backupdir = vim.fn.stdpath("cache") .. "/backup",
  },
}

_G.mo = mo or namespace

require("mvim.config").setup()
