local before_init = function(_, config)
  if vim.env.VIRTUAL_ENV then
    local python_bin = require("lspconfig.util").path.join(vim.env.VIRTUAL_ENV, "bin", "python3")
    config.settings.python.pythonPath = python_bin
  end
end

return {
  before_init = before_init,
  settings = {
    pylsp = {
      plugins = {
        pydocstyle = {
          enabled = false,
        },
        pycodestyle = {
          ignore = {},
          exclude = {},
          maxLineLength = 100,
        },
        isort = {
          enabled = true,
        },
        black = {
          enabled = true,
        },
        yapf = {
          enabled = false,
        },
      },
    },
  },
}
