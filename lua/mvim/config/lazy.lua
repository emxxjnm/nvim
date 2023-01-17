local fn = vim.fn
local icons = mo.style.icons

-- bootstrap lazy.nvim
local lazypath = fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.notify("cloning plugin manager...")
  fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end

vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

-- Install your plugins here
require("lazy").setup({
  spec = "mvim.plugins",
  -- checker = { enabled = true },
  defaults = { lazy = true },
  install = { colorscheme = { "catppuccin" } },
  ui = {
    border = mo.style.border.current,
    icons = {
      loaded = icons.misc.circle,
      not_loaded = icons.misc.uninstalled,
      cmd = icons.misc.cmd,
      config = icons.misc.setting,
      event = icons.lsp.kinds.event,
      ft = icons.documents.file,
      init = icons.misc.rocket,
      keys = icons.misc.key,
      plugin = icons.misc.electron,
      runtime = icons.misc.vim,
      source = icons.lsp.kinds.snippet,
      start = icons.dap.play,
      task = icons.misc.task,
      lazy = icons.misc.lazy,
      list = {
        icons.misc.creation,
        icons.misc.fish,
        icons.misc.star,
        icons.misc.pulse,
      },
    },
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
