---@return string? python path
local function get_python()
  if vim.env.VIRTUAL_ENV then
    return require("lspconfig.util").path.join(vim.env.VIRTUAL_ENV, "bin", "python")
  end
  return nil
end

local function get_mypy_config()
  local python_bin = get_python()
  local overrides = {}
  if python_bin then
    overrides = {
      "--python-executable",
      python_bin,
      true,
    }
  end
  return {
    enabled = true,
    dmypy = false,
    strict = false,
    live_mode = true,
    overrides = overrides,
  }
end

return {
  before_init = function(_, config)
    local python_bin = get_python()
    if python_bin then
      config.settings.python.pythonPath = python_bin
    end
  end,
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
        pylsp_mypy = get_mypy_config(),
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
