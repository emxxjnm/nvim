local M = {}

local function offset(name, ft)
  return {
    text = name,
    filetype = ft,
    text_align = "center",
    highlight = "PanelHeading",
  }
end

local function diagnostics_indicator(_, _, diagnostics)
  local symbols = { error = " ", warning = " ", info = " " }
  local result = {}
  for name, count in pairs(diagnostics) do
    if symbols[name] and count > 0 then
      table.insert(result, symbols[name] .. count)
    end
  end
  return #result > 0 and table.concat(result, " ") or ""
end

function M.setup()
  require("bufferline").setup({
    options = {
      mode = "buffers",
      numbers = "none",
      close_command = "bdelete! %d",
      right_mouse_command = "bdelete! %d",
      left_mouse_command = "buffer %d",
      middle_mouse_command = nil,
      indicator_icon = "▎",
      buffer_close_icon = "",
      modified_icon = "●",
      close_icon = "",
      left_trunc_marker = "",
      right_trunc_marker = "",
      name_formatter = nil,
      max_name_length = 18,
      max_prefix_length = 15,
      tab_size = 7,
      diagnostics = "nvim_lsp",
      diagnostics_update_in_insert = false,
      diagnostics_indicator = diagnostics_indicator,
      offsets = {
        offset("Explorer", "NvimTree"),
        offset("Undotree", "undotree"),
        offset("Packer", "packer"),
      },
      color_icons = true,
      show_buffer_icons = true,
      show_buffer_close_icons = false,
      show_buffer_default_icon = true,
      show_close_icon = false,
      show_tab_indicators = true,
      persist_buffer_sort = true,
      -- separator_style = "slant",
      enforce_regular_tabs = false,
      always_show_bufferline = true,
      sort_by = "insert_after_current",
    },
  })
end

return M
