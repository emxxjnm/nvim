local M = {}

function M.setup()
  require("nvim-autopairs").setup({
    check_ts = true,
    ts_config = {
      lua = { "string" },
    },
    disable_filetype = {
      "TelescopePrompt",
      "spectre_panel",
      "dap-repl",
    },
    ignored_next_char = string.gsub([[ [%w%%%'%[%"%.] ]], "%s+", ""),
    fast_wrap = {
      map = "<M-e>",
    },
  })

  mo.wrap_error("failed to setup nvim-autopairs completion", function()
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end)
end

return M
