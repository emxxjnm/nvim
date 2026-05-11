vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("mvim_formatting", { clear = true }),
  once = true,
  callback = function()
    -- conform
    vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

    require("conform").setup({
      formatters_by_ft = {
        sh = { "shfmt" },
        toml = { "taplo" },
        lua = { "stylua" },
        rust = { "rustfmt", lsp_format = "fallback" },
        go = { "goimports", lsp_format = "last" },
        nix = { "nixfmt" },
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
    })

    require("mvim.format").formatter = {
      name = "conform.nvim",
      format = function(buf)
        require("conform").format({ bufnr = buf })
      end,
    }

    -- nvim-lint
    vim.pack.add({ "https://github.com/mfussenegger/nvim-lint" })

    local lint = require("lint")

    local linters = {
      eslint_d = {
        condition = function(ctx)
          return vim.fs.find({ "eslint.config.js" }, { path = ctx.filename, upward = true })[1]
        end,
      },
      oxlint = {
        condition = function(ctx)
          return vim.fs.find({ ".oxlintrc.json" }, { path = ctx.filename, upward = true })[1]
        end,
      },
    }

    for name, linter in pairs(linters) do
      local cfg = lint.linters[name]
      if type(linter) == "table" and type(cfg) == "table" then
        lint.linters[name] = vim.tbl_deep_extend("force", cfg, linter)
      else
        lint.linters[name] = linter
      end
    end

    lint.linters_by_ft = {
      python = { "ruff" },
      typescript = { "eslint_d", "oxlint" },
      javascript = { "eslint_d", "oxlint" },
      vue = { "eslint_d", "oxlint" },
    }

    local function debounce(ms, fn)
      local timer = vim.uv.new_timer()
      return function(...)
        local argv = { ... }
        timer:start(ms, 0, function()
          timer:stop()
          vim.schedule_wrap(fn)(unpack(argv))
        end)
      end
    end

    local function do_lint()
      local names = lint._resolve_linter_by_ft(vim.bo.filetype)

      local ctx = { filename = vim.api.nvim_buf_get_name(0) }
      ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
      names = vim.tbl_filter(function(name)
        local linter = lint.linters[name]
        if not linter then
          vim.notify("Linter not found: " .. name, vim.log.levels.WARN)
        end
        return linter
          and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
      end, names)

      if #names > 0 then
        lint.try_lint(names)
      end
    end

    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
      group = vim.api.nvim_create_augroup("mvim_lint", { clear = true }),
      callback = debounce(100, do_lint),
    })

    require("mvim.format").setup()
  end,
})
