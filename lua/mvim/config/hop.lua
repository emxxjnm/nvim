local M = {}

function M.setup()
  local hop = require("hop")
  hop.setup({ keys = "etovxqpdygfbzcisuran" })

  local map = vim.keymap.set

  map({ "x", "n", "o" }, "f", function()
    hop.hint_char1({
      direction = require("hop.hint").HintDirection.AFTER_CURSOR,
      current_line_only = true,
    })
  end, { desc = "hop: Move to next char" })

  map({ "x", "n", "o" }, "F", function()
    hop.hint_char1({
      direction = require("hop.hint").HintDirection.BEFORE_CURSOR,
      current_line_only = true,
    })
  end, { desc = "hop: Move to previous char" })

  map({ "x", "n" }, "<leader>k", function()
    hop.hint_words()
  end, { desc = "hop: Move to any words in the current window" })

  map({ "x", "n" }, "<leader>j", function()
    hop.hint_lines()
  end, { desc = "hop: Move to beginning of the line in the current window" })
end

return M
