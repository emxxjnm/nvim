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
        pycodestyle = {
          indentSize = 4,
          maxLineLength = 100,
        },
        isort = {
          enabled = true,
        },
        black = {
          enabled = true,
        },
        pylsp_mypy = {
          enabled = true,
          dmypy = false,
          live_mode = true,
          strict = false,
        },
        pydocstyle = {
          enabled = false,
        },
        yapf = {
          enabled = false,
        },
      },
    },
  },
}
