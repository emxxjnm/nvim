local M = {}

function M.setup()
  local icons = mo.style.icons
  require("indent_blankline").setup({
    char = icons.documents.indent,
    char_list = { icons.documents.dash_indent },
    show_current_context = true,
    show_first_indent_level = false,
  })
end

return M
