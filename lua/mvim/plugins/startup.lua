local M = {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  opts = function()
    local banner = require("mvim.config").banner
    local logo = string.rep("\n", 7) .. banner .. "\n"
    local opts = {
      theme = "doom",
      hide = {
        statusline = false,
        tabline = false,
        winbar = false,
      },
      config = {
        header = vim.split(logo, "\n"),
        center = {
          {
            action = "ene | startinsert",
            desc = " New file",
            icon = " ",
            icon_hl = "Character",
            key = "n",
          },
          {
            action = "Telescope find_files",
            desc = " Find file",
            icon = " ",
            icon_hl = "Label",
            key = "f",
          },
          {
            action = "Telescope live_grep",
            desc = " Find text",
            icon = " ",
            icon_hl = "Special",
            key = "g",
          },
          {
            action = "Telescope oldfiles",
            desc = " Recent files",
            icon = " ",
            icon_hl = "Macro",
            key = "r",
          },
          {
            action = require("mvim.util").finder.config_files(),
            desc = " Config",
            icon = " ",
            icon_hl = "String",
            key = "c",
          },
          {
            action = "qa",
            desc = " Quit",
            icon = " ",
            icon_hl = "Error",
            key = "q",
          },
        },
        footer = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)

          local version = vim.version()

          return {
            string.format(
              " Neovim v%d.%d.%d%s",
              version.major,
              version.minor,
              version.patch,
              version.prerelease and "(nightly)" or ""
            ) .. " loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms",
          }
        end,
      },
    }

    for _, button in ipairs(opts.config.center) do
      button.key_format = "%s"
      button.key_hl = "Constant"
      button.desc_hl = "CursorLineNr"
      button.desc = button.desc .. string.rep(" ", 50 - #button.desc)
    end

    -- close Lazy and re-open when the dashboard is ready
    if vim.o.filetype == "lazy" then
      vim.cmd.close()
      vim.api.nvim_create_autocmd("User", {
        pattern = "DashboardLoaded",
        callback = function()
          require("lazy").show()
        end,
      })
    end

    return opts
  end,
}

return M
