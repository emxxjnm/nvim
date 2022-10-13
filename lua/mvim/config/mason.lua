local M = {}

function M.setup()
  local icons = mo.style.icons

  require("mason").setup({
    ui = {
      border = mo.style.border.current,
      icons = {
        package_installed = icons.misc.check,
        package_pending = icons.misc.refresh,
        package_uninstalled = icons.misc.cross,
      },
      keymaps = {
        apply_language_filter = "f",
      },
    },
  })
end

return M
