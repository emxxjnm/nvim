-- ts-comments + todo-comments: vim.schedule
vim.schedule(function()
  vim.pack.add({
    "https://github.com/folke/ts-comments.nvim",
    "https://github.com/folke/todo-comments.nvim",
  })

  require("ts-comments").setup({})

  require("todo-comments").setup({
    -- stylua: ignore
    keywords = {
      TODO = { icon = " ", color = Mo.C.palette.green },
      HACK = { icon = " ", color = Mo.C.palette.peach },
      NOTE = { icon = " ", color = Mo.C.palette.blue, alt = { "INFO" } },
      PERF = { icon = " ", color = Mo.C.palette.mauve, alt = { "OPTIM" } },
      TEST = { icon = " ", color = Mo.C.palette.teal, alt = { "PASSED", "FAILED" } },
      WARN = { icon = " ", color = Mo.C.palette.yellow, alt = { "WARNING", "XXX" } },
      FIX  = { icon = " ", color = Mo.C.palette.red, alt = { "FIXME", "FIXIT", "ISSUE" } },
    },
    gui_style = { fg = "BOLD" },
    highlight = {
      before = "",
      keyword = "wide_fg",
      after = "",
    },
  })

  -- stylua: ignore start
  local keymap = vim.keymap.set
  keymap("n", "<leader>fT", function() Snacks.picker.todo_comments() end, { desc = "Find TODOs" })
  keymap("n", "[T", function() require("todo-comments").jump_prev() end, { desc = "Prev TODO comment" })
  keymap("n", "]T", function() require("todo-comments").jump_next() end, { desc = "Next TODO comment" })
  -- stylua: ignore end
end)

-- autopairs: InsertEnter trigger
vim.api.nvim_create_autocmd("InsertEnter", {
  once = true,
  callback = function()
    vim.pack.add({ "https://github.com/windwp/nvim-autopairs" })

    local autopairs = require("nvim-autopairs")
    local Rule = require("nvim-autopairs.rule")
    local cond = require("nvim-autopairs.conds")

    autopairs.setup({ fast_wrap = { map = "<M-e>" } })
    autopairs.add_rules({
      Rule("<", ">", "rust"):with_pair(cond.before_regex("%a+:?:?$", 3)):with_move(function(args)
        return args.char == ">"
      end),
    })
  end,
})

-- surround: vim.schedule
vim.g.nvim_surround_no_mappings = true
vim.schedule(function()
  vim.pack.add({ "https://github.com/kylechui/nvim-surround" })
  require("nvim-surround").setup({ move_cursor = false })
  -- stylua: ignore start
  vim.keymap.set("n", "gsa", "<Plug>(nvim-surround-normal)", { desc = "Add surround" })
  vim.keymap.set("x", "gsa", "<Plug>(nvim-surround-visual)", { desc = "Add surround" })
  vim.keymap.set("n", "gsd", "<Plug>(nvim-surround-delete)", { desc = "Delete surround" })
  vim.keymap.set("n", "gsc", "<Plug>(nvim-surround-change)", { desc = "Change surround" })
  vim.keymap.set("i", "<C-g>s", "<Plug>(nvim-surround-insert)", { desc = "Add surround" })
  vim.keymap.set("i", "<C-g>S", "<Plug>(nvim-surround-insert-line)", { desc = "Add surround line" })
  -- stylua: ignore end
end)
