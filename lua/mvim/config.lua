require("mvim.styles")
local icons = mo.styles.icons

local M = {}

function M.bootstrap()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

  if not vim.loop.fs_stat(lazypath) then
    vim.notify("cloning plugin manager, will take a few minutes...")
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "--single-branch",
      "https://github.com/folke/lazy.nvim.git",
      lazypath,
    })
  end
  vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

  require("lazy").setup({
    spec = "mvim.plugins",
    defaults = { lazy = true },
    install = { colorscheme = { "catppuccin" } },
    change_detection = { notify = false },
    ui = {
      border = mo.styles.border,
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
end

function M.load(name)
  local u = require("lazy.core.util")
  local mod = "mvim." .. name
  u.try(function()
    require(mod)
  end, {
    msg = "Failed loading " .. mod,
    on_error = function(msg)
      local modpath = require("lazy.core.cache").find(mod)
      if modpath then
        u.error(msg)
      end
    end,
  })
  if vim.bo.filetype == "lazy" then
    -- HACK: LazyVim may have overwritten options of the Lazy ui, so reset this here
    vim.cmd([[do VimResized]])
  end
end

function M.setup()
  -- bootstrap lazy.nvim
  M.bootstrap()

  -- setup keymaps & autocmds
  if vim.fn.argc() == 0 then
    -- autocmds and keymaps can wait to load
    require("mvim.utils").augroup("OnMvimSetup", {
      {
        event = "User",
        pattern = "VeryLazy",
        command = function()
          M.load("autocmds")
          M.load("keymaps")
        end,
      },
    })
  else
    M.load("autocmds")
    M.load("keymaps")
  end
end

return M
