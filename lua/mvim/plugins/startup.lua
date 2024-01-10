local M = {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  opts = function()
    local banner = require("mvim.config").banner
    local logo = string.rep("\n", 8) .. banner .. "\n\n"
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
            desc_hl = "CursorLineNr",
            icon = " ",
            icon_hl = "Character",
            key = "n",
            key_hl = "Constant",
            key_format = "%s",
          },
          {
            action = "Telescope find_files",
            desc = " Find file",
            desc_hl = "CursorLineNr",
            icon = " ",
            icon_hl = "Label",
            key = "f",
            key_hl = "Constant",
            key_format = "%s",
          },
          {
            action = "Telescope live_grep",
            desc = " Find text",
            desc_hl = "CursorLineNr",
            icon = " ",
            icon_hl = "Special",
            key = "g",
            key_hl = "Constant",
            key_format = "%s",
          },
          {
            action = "Telescope oldfiles",
            desc = " Recent files",
            desc_hl = "CursorLineNr",
            icon = " ",
            icon_hl = "Macro",
            key = "r",
            key_hl = "Constant",
            key_format = "%s",
          },
          {
            action = require("mvim.util").finder.config_files(),
            desc = " Config",
            desc_hl = "CursorLineNr",
            icon = " ",
            icon_hl = "String",
            key = "c",
            key_hl = "Constant",
            key_format = "%s",
          },
          {
            action = "qa",
            desc = " Quit",
            desc_hl = "CursorLineNr",
            icon = " ",
            icon_hl = "Error",
            key = "q",
            key_hl = "Constant",
            key_format = "%s",
          },
        },
        footer = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)

          local version = vim.version()

          return {
            string.format(
              " Neovim v%d.%d.%d%s",
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
      button.desc = button.desc .. string.rep(" ", 48 - #button.desc)
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
