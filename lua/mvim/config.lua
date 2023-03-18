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
        loaded = icons.plugin.installed,
        not_loaded = icons.plugin.uninstalled,
        cmd = icons.misc.terminal,
        config = icons.misc.setting,
        event = icons.lsp.kinds.event,
        ft = icons.documents.file,
        init = icons.dap.controls.play,
        keys = icons.misc.key,
        plugin = icons.plugin.plugin,
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

---@param name "autocmds" | "options" | "keymaps"
function M.load(name)
  local Util = require("lazy.core.util")
  local function _load(mod)
    Util.try(function()
      require(mod)
    end, {
      msg = "Failed loading " .. mod,
      on_error = function(msg)
        local info = require("lazy.core.cache").find(mod)
        if info == nil or (type(info) == "table" and #info == 0) then
          return
        end
        Util.error(msg)
      end,
    })
  end
  _load("mvim" .. name)
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
    require("mvim.utils").augroup("MVim", {
      event = "User",
      pattern = "VeryLazy",
      command = function()
        M.load("autocmds")
        M.load("keymaps")
      end,
      desc = "Load autocmds and keymaps lazy",
    })
  else
    M.load("autocmds")
    M.load("keymaps")
  end
end

return M
