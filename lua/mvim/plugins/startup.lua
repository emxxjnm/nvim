local M = {
  "goolord/alpha-nvim",
  event = "VimEnter",
  opts = function()
    local dashboard = require("alpha.themes.dashboard")

    local function button(hl, ...)
      local btn = dashboard.button(...)
      local details = select(2, ...)
      local icon = details:match("[^%w%s]+")
      btn.opts.hl = { { hl, 0, #icon + 1 } }
      btn.opts.hl_shortcut = "Title"
      return btn
    end

    dashboard.section.header.val = mo.styles.banner
    dashboard.section.buttons.val = {
      button("Character", "n", I.documents.new_file .. "  New file", "<Cmd>ene<Bar>star<CR>"),
      button("Label", "g", I.lsp.kinds.text .. "  Find text", "<Cmd>Telescope live_grep_args<CR>"),
      button("Special", "f", I.misc.search .. "  Find file", "<Cmd>Telescope find_files<CR>"),
      button("Macro", "r", I.misc.history .. "  Recent files", "<Cmd>Telescope oldfiles<CR>"),
      button("Winbar", "p", I.misc.repo .. "  Recent project", "<Cmd>Telescope projects<CR>"),
      button("Error", "q", I.misc.exit .. "  Quit NVIM", "<Cmd>quitall<CR>"),
    }

    dashboard.section.header.opts.hl = "Function"
    dashboard.section.footer.opts.hl = "Conceal"

    dashboard.config.layout = {
      { type = "padding", val = 5 },
      dashboard.section.header,
      { type = "padding", val = 1 },
      dashboard.section.buttons,
      { type = "padding", val = 1 },
      dashboard.section.footer,
    }

    return dashboard
  end,
  config = function(_, dashboard)
    -- close Lazy and re-open when the dashboard is ready
    if vim.o.filetype == "lazy" then
      vim.cmd.close()
      vim.api.nvim_create_autocmd("User", {
        pattern = "AlphaReady",
        callback = function()
          require("lazy").show()
        end,
      })
    end

    require("alpha").setup(dashboard.config)

    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyVimStarted",
      callback = function()
        local stats = require("lazy").stats()
        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
        local v = vim.version()
        local version = string.format(
          "%s Neovim v%d.%d.%d%s",
          I.misc.vim,
          v.major,
          v.minor,
          v.patch,
          v.prerelease and "(nightly)" or ""
        )

        dashboard.section.footer.val = string.format(
          "--- %s loaded %d %s plugins in %d ms ---",
          version,
          stats.count,
          I.plugin.plugin,
          ms
        )
        pcall(vim.cmd.AlphaRedraw)
      end,
    })
  end,
}

return M
