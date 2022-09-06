local ok, null_ls = mo.require("null-ls")
if not ok then
  return
end

null_ls.setup({
  log_level = "info",
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
})
