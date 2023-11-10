require("mvim.styles")

local M = {}

function M.bootstrap()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

  if not vim.loop.fs_stat(lazypath) then
    vim.notify("Cloning plugin manager, will take a few minutes...")
    local output = vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "--single-branch",
      "https://github.com/folke/lazy.nvim.git",
      lazypath,
    })
    if vim.api.nvim_get_vvar("shell_error") ~= 0 then
      vim.api.nvim_err_writeln("Error cloning lazy.nvim repository...\n\n" .. output)
    end
  end
  vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

  require("lazy").setup({
    spec = "mvim.plugins",
    defaults = { lazy = true },
    install = { colorscheme = { "catppuccin" } },
    change_detection = { notify = false },
    checker = { enabled = true, notify = false },
    ui = {
      border = mo.styles.border,
      icons = {
        loaded = I.plugin.installed,
        not_loaded = I.plugin.uninstalled,
        cmd = I.misc.terminal,
        config = I.misc.setting,
        event = I.lsp.kinds.event,
        ft = I.documents.file,
        init = I.dap.controls.play,
        keys = I.misc.key,
        plugin = I.plugin.plugin .. " ",
        runtime = I.misc.vim,
        source = I.lsp.kinds.snippet,
        start = I.dap.play,
        task = I.misc.task,
        lazy = I.misc.lazy,
        list = {
          I.misc.creation,
          I.misc.fish,
          I.misc.star,
          I.misc.pulse,
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
  local function _load(mod)
    local U = require("lazy.core.util")

    U.try(function()
      require(mod)
    end, {
      msg = "Failed loading " .. mod,
      on_error = function(msg)
        local info = require("lazy.core.cache").find(mod)
        if info == nil or (type(info) == "table" and #info == 0) then
          return
        end
        U.error(msg)
      end,
    })
  end

  _load("mvim.config." .. name)

  if vim.bo.filetype == "lazy" then
    vim.cmd([[do VimResized]])
  end
end

M.did_init = false
function M.init()
  if not M.did_init then
    M.did_init = true

    M.load("options")
  end
end

function M.setup()
  _G.I = mo.styles.icons

  -- bootstrap lazy.nvim
  M.bootstrap()

  local lazy_autocmds = vim.fn.argc(-1) == 0
  if not lazy_autocmds then
    M.load("autocmds")
  end

  require("mvim.util").augroup("Mvim", {
    pattern = "VeryLazy",
    event = "User",
    command = function()
      if lazy_autocmds then
        M.load("autocmds")
      end
      M.load("keymaps")

      require("mvim.util").format.setup()
    end,
  })
end

return M
