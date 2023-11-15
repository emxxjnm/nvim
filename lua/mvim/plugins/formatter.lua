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
            local format_opts = vim.tbl_deep_extend(
              "force",
              opts.format_opts[ft] or opts.format_opts.default,
              { bufnr = buf }
            )
            require("conform").format(format_opts)
          end,
        }
      end)
    end,
    opts = {
      format_opts = {
        default = {
          formatters = nil,
          timeout_ms = 500,
          lsp_fallback = true,
        },
        go = {
          timeout_ms = 500,
          lsp_fallback = "always",
        },
      },
      formatters_by_ft = {
        sh = { "shfmt" },
        lua = { "stylua" },
        go = { "goimports" },
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        vue = { "stylelint", "eslint_d" },
      },
      formatters = {
        shfmt = { prepend_args = { "-i", "2", "-ci" } },
      },
    },
  },
}
