local M = {}

function M.setup()
  local leap = require("leap")

  leap.setup({
    equivalence_classes = { " \t\r\n", "([{", ")]}", "`\"'" },
  })

  vim.keymap.set("n", "s", function()
    leap.leap({})
  end, { remap = true, silent = true })

  vim.keymap.set("n", "S", function()
    leap.leap({ backward = true })
  end, { remap = true, silent = true })
end

return M
