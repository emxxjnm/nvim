local M = {}

function M.setup()
  require("project_nvim").setup({
    manual_mode = false,
    detection_methods = { "pattern" },
    patterns = { ".git", "pyproject.toml", "go.mod" },
    ignore_lsp = {},
    exclude_dirs = {},
    show_hidden = true,
    silent_chdir = true,
    datapath = vim.fn.stdpath("data"),
  })

  local ok, telescope = mo.require("telescope")
  if not ok then
    return
  end

  telescope.load_extension("projects")
end

return M
