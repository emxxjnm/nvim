local status_ok, bufferline = pcall(require, "bufferline")
if not status_ok then
  return
end

bufferline.setup({
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
    diagnostics_indicator = function(_, _, diagnostics_dict)
      local s = " "
      local diagnostics_signs = {
        error = "",
        warning = "",
        default = "",
      }
      for e, n in pairs(diagnostics_dict) do
        local sym = diagnostics_signs[e] or diagnostics_signs.default
        s = s .. (#s > 1 and " " or "") .. sym .. " " .. n
      end
      return s
    end,
    -- custom_filter = function(buf_number)
    --   if vim.bo[buf_number].filetype ~= "dap-repl" then
    --     return true
    --   end
    -- end,
    offsets = {
      {
        filetype = "NvimTree",
        text = "File Explorer",
        text_align = "center",
        highlight = "PanelHeading",
      },
      {
        filetype = "undotree",
        text = "Undotree",
        text_align = "center",
        highlight = "PanelHeading",
      },
      {
        filetype = "packer",
        text = "Packer",
        text_align = "center",
        hightlight = "PanelHeading",
      },
    },
    color_icons = true,
    show_buffer_icons = true,
    show_buffer_close_icons = false,
    show_buffer_default_icon = true,
    show_close_icon = false,
    show_tab_indicators = true,
    persist_buffer_sort = true,
    -- separator_style = "slant",
    separator_style = "thin",
    enforce_regular_tabs = false,
    always_show_bufferline = true,
    sort_by = "id",
  },
})
