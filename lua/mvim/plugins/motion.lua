local M = {
  "ggandor/leap.nvim",
  keys = {
    {
      "s",
      function()
        require("leap").leap({})
      end,
      desc = "Leap forward",
    },
    {
      "S",
      function()
        require("leap").leap({ backward = true })
      end,
      desc = "Leap backward",
    },
  },
  dependencies = {
    "ggandor/flit.nvim",
    keys = { "f", "F" },
    opts = {
      labeled_modes = "nvo",
    },
  },
  opts = {
    equivalence_classes = { " \t\r\n", "([{", ")]}", "`\"'" },
  },
}

return M
