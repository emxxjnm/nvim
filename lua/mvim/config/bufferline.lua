local M = {}

function M.setup()
  local bufferline = require("bufferline")
  local icons = mo.style.icons

  bufferline.setup({
    options = {
      tab_size = 7,
      diagnostics = "nvim_lsp",
      diagnostics_update_in_insert = false,
      diagnostics_indicator = function(_, _, diagnostics)
        local symbols = {
          error = icons.diagnostics.error .. " ",
          warning = icons.diagnostics.warn .. " ",
          info = icons.diagnostics.info .. " ",
          hint = icons.diagnostics.hint .. " ",
        }
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
          filetype = "neo-tree",
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
    highlights = require("catppuccin.groups.integrations.bufferline").get(),
  })

  local map = vim.keymap.set
  map("n", "[b", function()
    bufferline.cycle(-1)
  end, { desc = "bufferline: Move prev" })

  map("n", "]b", function()
    bufferline.cycle(1)
  end, { desc = "bufferline: Move next" })
end

return M
