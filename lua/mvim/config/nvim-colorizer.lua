local M = {}

function M.setup()
  require("colorizer").setup({
    filetypes = {
      "css",
      "vue",
      "scss",
      "less",
      "html",
      "lua",
    },
    user_default_options = {
      names = false,
      mode = "virtualtext",
      virtualtext = mo.style.icons.misc.cloud .. " ",
    },
  })
end

return M
