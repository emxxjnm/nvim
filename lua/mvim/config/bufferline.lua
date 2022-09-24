local M = {}

function M.setup()
  local bufferline = require("bufferline")
  bufferline.setup({
    options = {
      tab_size = 7,
      diagnostics = "nvim_lsp",
      diagnostics_update_in_insert = false,
      diagnostics_indicator = function(_, _, diagnostics)
        local symbols = { error = " ", warning = " ", info = " ", hint = " " }
        local result = {}
        for name, count in pairs(diagnostics) do
          if symbols[name] and count > 0 then
            table.insert(result, symbols[name] .. count)
          end
        end
        return #result > 0 and table.concat(result, " ") or ""
      end,
      offsets = {
        {
          filetype = "NvimTree",
          text = "Explorer",
          text_align = "center",
          separator = true,
          highlight = "PanelHeading",
        },
        {
          filetype = "undotree",
          text = "Undotree",
          separator = true,
          text_align = "center",
          highlight = "PanelHeading",
        },
        {
          filetype = "packer",
          text = "Packer",
          separator = true,
          text_align = "center",
          hightlight = "PanelHeading",
        },
      },
      show_buffer_close_icons = false,
      show_close_icon = false,
      sort_by = "insert_after_current",
    },
  })

  local map = vim.keymap.set
  map("n", "[b", function()
    bufferline.cycle(-1)
  end, { desc = "bufferline:" })

  map("n", "]b", function()
    bufferline.cycle(1)
  end, { desc = "bufferline:" })
end

return M
