local status_ok, bufferline = pcall(require, "bufferline")
if not status_ok then
  return
end

bufferline.setup({
  options = {
    mode = "buffers", -- set to "tabs" to only show tabpages instead
    numbers = "none", -- | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
    close_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
    right_mouse_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
    left_mouse_command = "buffer %d", -- can be a string | function, see "Mouse actions"
    middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"
    -- NOTE: this plugin is designed with this icon in mind,
    -- and so changing this is NOT recommended, this is intended
    -- as an escape hatch for people who cannot bear it for whatever reason
    indicator_icon = "▎",
    buffer_close_icon = "",
    modified_icon = "●",
    close_icon = "",
    left_trunc_marker = "",
    right_trunc_marker = "",
    --- name_formatter can be used to change the buffer's label in the bufferline.
    --- Please note some names can/will break the
    --- bufferline so use this at your discretion knowing that it has
    --- some limitations that will *NOT* be fixed.
    name_formatter = nil, -- buf contains a "name", "path" and "bufnr"
    max_name_length = 18,
    max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
    tab_size = 7,
    diagnostics = "nvim_lsp", -- false | "nvim_lsp" | "coc",
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
    -- NOTE: this will be called a lot so don't do any heavy processing here
    custom_filter = nil,
    offsets = {
      {
        filetype = "NvimTree",
        text = "File Explorer",
        text_align = "center",
        highlight = "PanelHeading"
      },
      {
        filetype = "undotree",
        text = "Undotree",
        text_align = "center",
        highlight = "PanelHeading"
      },
      {
        filetype = "packer",
        text = "Packer",
        text_align = "center",
        hightlight = "PanelHeading",
      }
    },
    show_buffer_icons = true, --| false, -- disable filetype icons for buffers
    show_buffer_close_icons = false, --| false,
    show_close_icon = false, --| false | true
    show_tab_indicators = true, -- | false,
    persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
    -- can also be a table containing 2 custom separators
    -- [focused and unfocused]. eg: { '|', '|' }
    separator_style = "slant", --| "slant" | "thick" | "thin" | { 'any', 'any' },
    enforce_regular_tabs = false, -- true | true,
    always_show_bufferline = true, -- true | false,
    sort_by = "id", -- 'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs'
  },
})
