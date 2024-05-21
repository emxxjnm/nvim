return {
  {
    "stevearc/conform.nvim",
    cmd = "ConformInfo",
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
      require("mvim.util").on_very_lazy(function()
        require("mvim.util").format.formatter = {
          name = "conform.nvim",
          format = function(buf)
            local ft = vim.bo[buf].filetype
            local opts = require("mvim.util").opts("conform.nvim")
            local extra_args = opts.extra_lang_opts[ft] or {}
            require("conform").format(vim.tbl_deep_extend("force", { bufnr = buf }, extra_args))
          end,
        }
      end)
    end,
    opts = {
      extra_lang_opts = {
        go = {
          lsp_fallback = "always",
        },
        rust = {
          lsp_fallback = true,
        },
      },
      formatters_by_ft = {
        sh = { "shfmt" },
        lua = { "stylua" },
        go = { "goimports" },
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        vue = { "eslint_d", "stylelint" },
        python = { "ruff_fix", "ruff_format" },
      },
      formatters = {
        shfmt = { prepend_args = { "-i", "2", "-ci" } },
        eslint_d = {
          condition = function(self, ctx)
            return vim.fs.find(
              { "eslint.config.js", ".eslintrc.cjs" },
              { path = ctx.filename, upward = true }
            )[1]
          end,
        },
        stylelint = {
          condition = function(self, ctx)
            return vim.fs.find(
              { ".stylelintrc", "stylelint.config.js", "stylelint.config.cjs" },
              { path = ctx.filename, upward = true }
            )[1]
          end,
        },
      },
    },
  },
}
