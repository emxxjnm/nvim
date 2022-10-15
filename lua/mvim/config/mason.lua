local M = {}

function M.setup()
  local icons = mo.style.icons

  require("mason").setup({
    ui = {
      border = mo.style.border.current,
      icons = {
        package_installed = icons.misc.installed,
        package_pending = icons.misc.pedding,
        package_uninstalled = icons.misc.uninstalled,
      },
      keymaps = {
        apply_language_filter = "f",
      },
    },
  })
end

return M
