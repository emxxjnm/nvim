local M = {}

function M.setup()
  local null_ls = require("null-ls")
  local default_opts = require("mvim.lsp").get_opts()
  local opts = vim.tbl_deep_extend("force", default_opts, {})
  null_ls.setup(opts)

  -- use ftplugin
  local service = require("mvim.lsp.service")
  service.register_sources({
    { command = "stylua", extra_args = {}, filetypes = { "lua" } },
    { command = "shfmt", extra_args = { "-i", "2", "-ci", "-bn" }, filetypes = { "sh" } },
  }, null_ls.methods.FORMATTING)
  service.register_sources({
    { command = "luacheck", extra_args = {}, filetypes = { "lua" } },
    { command = "markdownlint", filetypes = { "markdown" } },
  }, null_ls.methods.DIAGNOSTICS)
end

return M
