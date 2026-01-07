return {
  "stevearc/conform.nvim",
  cmd = "ConformInfo",
  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    Mo.U.on_very_lazy(function()
      Mo.U.format.formatter = {
        name = "conform.nvim",
        format = function(buf)
          require("conform").format({ bufnr = buf })
        end,
      }
    end)
  end,
  opts = {
    formatters_by_ft = {
      sh = { "shfmt" },
      toml = { "taplo" },
      lua = { "stylua" },
      rust = { "rustfmt", lsp_format = "fallback" },
      go = { "goimports", lsp_format = "last" },
      nix = { "alejandra" },
      javascript = { "eslint_d", "oxfmt" },
      typescript = { "eslint_d", "oxfmt" },
      vue = { "eslint_d", "oxfmt" },
      python = { "ruff_fix", "ruff_format" },
    },
    formatters = {
      shfmt = { prepend_args = { "-i", "2", "-ci" } },
      eslint_d = {
        condition = function(self, ctx)
          return vim.fs.find({ "eslint.config.js" }, { path = ctx.filename, upward = true })[1]
        end,
      },
      oxfmt = {
        condition = function(self, ctx)
          return vim.fs.find({ ".oxfmtrc.json" }, { path = ctx.filename, upward = true })[1]
        end,
      },
    },
  },
}
