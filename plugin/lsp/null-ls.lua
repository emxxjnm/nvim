local ok, null_ls = pcall(require, "null-ls")
if not ok then
  return
end

local default_opts = require("mvim.lsp.config").get_common_opts()

null_ls.setup(vim.tbl_deep_extend("force", default_opts, {
  sources = {
    -- lua
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.diagnostics.luacheck,

    -- python
    null_ls.builtins.formatting.isort,
    null_ls.builtins.diagnostics.mypy,

    -- shell
    -- null_ls.builtins.diagnostics.shellcheck,

    -- markdown
    null_ls.builtins.formatting.markdownlint,
    null_ls.builtins.diagnostics.markdownlint,
  },
}))
