local ok, null_ls = mo.require("null-ls")
if not ok then
  return
end

null_ls.setup({
  log_level = "info",
  sources = {
    -- lua
    null_ls.builtins.formatting.stylua.with({
      condition = function(utils)
        return vim.fn.executable("stylua")
          and utils.root_has_file({ "stylua..toml", ".stylua.toml" })
      end,
    }),

    -- shell
    null_ls.builtins.diagnostics.shellcheck,
    null_ls.builtins.formatting.shfmt.with({
      extra_args = { "-i", "2", "-ci", "-bn" },
    }),

    -- markdown
    null_ls.builtins.formatting.markdownlint,
    null_ls.builtins.diagnostics.markdownlint,
  },
})
