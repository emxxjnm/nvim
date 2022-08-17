local ok, null_ls = pcall(require, "null-ls")
if not ok then
  return
end

local default_opts = require("mvim.lsp.config").get_common_opts()

null_ls.setup(vim.tbl_deep_extend("force", default_opts, {
  sources = {
    -- lua
    null_ls.builtins.formatting.stylua.with({
      condition = function()
        return vim.fn.executable("stylua")
          and not vim.tbl_isempty(
            vim.fs.find(
              { ".stylua.toml", "stylua.toml" },
              { path = vim.fn.expand("%:p"), upward = true }
            )
          )
      end,
    }),

    -- shell
    -- null_ls.builtins.diagnostics.shellcheck,
    null_ls.builtins.formatting.shfmt,

    -- markdown
    null_ls.builtins.formatting.markdownlint,
    null_ls.builtins.diagnostics.markdownlint,
  },
}))
