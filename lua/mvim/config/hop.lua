local M = {}

function M.setup()
  local hop = require("hop")

  hop.setup({
    keys = "etovxqpdygfbzcisuran",
  })

  local map = vim.keymap.set
  local hint = require("hop.hint")

  map({ "x", "n", "o" }, "f", function()
    hop.hint_char1({
      direction = hint.HintDirection.AFTER_CURSOR,
      multi_windows = true,
    })
  end, { silent = true, remap = true, desc = "hop: Move to next character" })

  map({ "x", "n", "o" }, "F", function()
    hop.hint_char1({
      direction = hint.HintDirection.BEFORE_CURSOR,
      multi_windows = true,
    })
  end, { silent = true, remap = true, desc = "hop: Move to prev character" })

  map({ "x", "n", "o" }, "s", function()
    hop.hint_char2({
      direction = hint.HintDirection.AFTER_CURSOR,
      multi_windows = true,
    })
  end, { silent = true, remap = true, desc = "hop: Move to next bigrams" })

  map({ "x", "n", "o" }, "S", function()
    hop.hint_char2({
      direction = hint.HintDirection.BEFORE_CURSOR,
      multi_windows = true,
    })
  end, { silent = true, remap = true, desc = "hop: Move to prev bigrams" })

  map({ "x", "n" }, "<leader>k", function()
    hop.hint_words()
  end, { desc = "hop: Move to any words in the current window" })

  map({ "x", "n" }, "<leader>j", function()
    hop.hint_lines()
  end, { desc = "hop: Move to beginning of the line in the current window" })
end

return M
