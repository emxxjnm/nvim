vim.schedule(function()
  vim.pack.add({
    "https://github.com/folke/flash.nvim",
    "https://github.com/folke/which-key.nvim",
    "https://github.com/echasnovski/mini.ai",
  })

  -- flash
  require("flash").setup({
    jump = { pos = "end", offset = 0 },
    modes = {
      char = {
        jump_labels = function(motion)
          return vim.v.count == 0 and motion:find("[ftFT]")
        end,
        jump = { autojump = true },
      },
    },
    prompt = {
      enabled = true,
      prefix = { { " 󰉂 ", "FlashPromptIcon" } },
    },
  })

  -- stylua: ignore start
  local keymap = vim.keymap.set
  keymap({ "n", "x", "o" }, "s", function() require("flash").jump() end, { desc = "Flash" })
  keymap({ "n", "x", "o" }, "S", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })
  -- stylua: ignore end

  -- which-key
  require("which-key").setup({
    spec = {
      { "<leader>a", group = "ai", icon = " ", mode = { "n", "v" } },
      { "<leader>b", group = "buffer", icon = " " },
      { "<leader>c", group = "code", icon = " " },
      { "<leader>d", group = "debug", icon = " " },
      { "<leader>f", group = "find", icon = " " },
      { "<leader>g", group = "git", icon = " " },
      { "<leader>l", group = "lsp", icon = " " },
      { "<leader>m", group = "markdown", icon = " " },
      { "<leader>n", group = "notification", icon = "󱅫 " },
      { "<leader>t", group = "test", icon = " " },
      { "<leader>o", group = "option", icon = "󰘵 " },
      { "<leader>p", group = "package", icon = " " },
      { "[", group = "prev" },
      { "]", group = "next" },
    },
    win = {
      title = false,
      no_overlap = false,
      border = Mo.C.border,
    },
    layout = { spacing = 5 },
    plugins = {
      marks = false,
      registers = false,
    },
    show_help = false,
  })

  -- mini.ai
  local ai = require("mini.ai")
  ai.setup({
    n_lines = 500,
    custom_textobjects = {
      o = ai.gen_spec.treesitter({
        a = { "@block.outer", "@conditional.outer", "@loop.outer" },
        i = { "@block.inner", "@conditional.inner", "@loop.inner" },
      }),
      f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
      c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
      t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
      d = { "%f[%d]%d+" },
      e = {
        {
          "%u[%l%d]+%f[^%l%d]",
          "%f[%S][%l%d]+%f[^%l%d]",
          "%f[%P][%l%d]+%f[^%l%d]",
          "^[%l%d]+%f[^%l%d]",
        },
        "^().*()$",
      },
    },
  })
end)
