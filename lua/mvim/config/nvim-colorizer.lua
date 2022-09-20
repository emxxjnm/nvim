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
      mode = "virtualtext",
      virtualtext = " ",
    },
  })
end

return M
