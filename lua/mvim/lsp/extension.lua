local M = {}

function M.setup()
  local null_ls = require("null-ls")
  local default_opts = require("mvim.lsp").get_opts()
  local opts = vim.tbl_deep_extend("force", default_opts, {})
  null_ls.setup(opts)

  -- use ftplugin
  local service = require("mvim.lsp.service")
  local helper = require("null-ls.helpers")
  local utils = require("null-ls.utils")

  service.register_sources({
    { command = "stylua", extra_args = {}, filetypes = { "lua" } },
    { command = "shfmt", extra_args = { "-i", "2", "-ci", "-bn" }, filetypes = { "sh" } },
    { command = "markdownlint", extra_args = {}, filetypes = { "markdown" } },
    { command = "isort", filetypes = { "python" } },
  }, null_ls.methods.FORMATTING)
  service.register_sources({
    {
      command = "luacheck",
      extra_args = {},
      filetypes = { "lua" },
      cwd = helper.cache.by_bufnr(function(params)
        return utils.root_pattern(".luacheckrc")(params.bufname)
      end),
      runtime_condition = helper.cache.by_bufnr(function(params)
        return utils.path.exists(utils.path.join(params.root, ".luacheckrc"))
      end),
    },
    { command = "markdownlint", filetypes = { "markdown" } },
    { command = "mypy", filetypes = { "python" } },
  }, null_ls.methods.DIAGNOSTICS)
end

return M
