local M = {}
local icons = mo.style.icons
local colors = mo.style.palettes

function M.setup()
  local bufferline = require("bufferline")

  bufferline.setup({
    options = {
      indicator = { icon = icons.misc.indicator, style = "icon" },
      buffer_close_icon = icons.misc.cross,
      modified_icon = icons.misc.dot,
      close_icon = icons.misc.bold_close,
      left_trunc_marker = icons.misc.triangle_left,
      right_trunc_marker = icons.misc.triangle_right,
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
          separator = true,
          text_align = "center",
          highlight = "PanelHeading",
        },
        {
          filetype = "neo-tree",
          text = "Explorer",
          separator = true,
          text_align = "center",
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
          highlight = "PanelHeading",
        },
        {
          filetype = "dapui_scopes",
          text = "Debugger",
          separator = true,
          text_align = "center",
          highlight = "PanelHeading",
        },
      },
      show_buffer_close_icons = false,
      show_close_icon = false,
      sort_by = "insert_after_current",
    },
    highlights = require("catppuccin.groups.integrations.bufferline").get({
      custom = {
        all = {
          buffer_selected = { fg = colors.lavender },
        },
      },
    }),
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
