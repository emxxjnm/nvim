local M = {
  "nvim-neo-tree/neo-tree.nvim",
  cmd = "Neotree",
  keys = {
    {
      "<C-n>",
      function()
        require("neo-tree.command").execute({ toggle = true, reveal = true })
      end,
      desc = "Explorer(NeoTree)",
    },
  },
  init = function()
    if vim.fn.argc(-1) == 1 then
      local stat = vim.uv.fs_stat(vim.api.nvim_buf_get_name(0))
      if stat and stat.type == "directory" then
        require("neo-tree")
      end
    end
  end,
  opts = function()
    local events = require("neo-tree.events")
    local exporter = require("mvim.util").exporter

    return {
      source_selector = {
        winbar = true,
        separator = "",
        content_layout = "center",
        truncation_character = "",
        sources = {
          { source = "filesystem", display_name = "󱉭 Files" },
          { source = "buffers", display_name = " Buffers" },
          { source = "git_status", display_name = "󰊢 Git" },
        },
      },
      close_if_last_window = true,
      use_default_mappings = false,
      popup_border_style = "rounded", -- no support "none"
      event_handlers = {
        {
          event = events.FILE_OPENED,
          handler = function()
            require("neo-tree.command").execute({ action = "close" })
          end,
        },
        {
          event = events.FILE_MOVED,
          handler = function(data)
            exporter.on_renamed(data.source, data.destination)
          end,
        },
        {
          event = events.FILE_RENAMED,
          handler = function(data)
            exporter.on_renamed(data.source, data.destination)
          end,
        },
      },
      default_component_configs = {
        icon = {
          folder_closed = "󰉋",
          folder_open = "󰝰",
          folder_empty = "󰉖",
          folder_empty_open = "󰷏",
          default = "󰡯",
        },
        modified = { symbol = "●" },
        name = {
          trailing_slash = false,
          highlight_opened_files = true,
          use_git_status_colors = true,
        },
        git_status = {
          symbols = {
            added = " ", --    󰐖 󰐗 󰜄
            modified = " ", --    󱗜 󰏬 󰛿 󰏭 󰝶 󱗝
            deleted = " ", --    󰍵 󰍶 󰛲
            renamed = " ", --  󰜵 󰁖 󰜶
            ignored = " ", --      slash

            untracked = " ", --   󰻂 󰎒 󰩳 󰓏  󰩴 󰦤 
            unstaged = " ", --  󰒉   󰄲 󰏝 󰄱 󰙀 󰔌   󰆟
            staged = " ", --        󰗠 󰽢 󰏝 󰄲 󰱒 󰆟
            conflict = "󰅗 ", --        󰅗 󰅙
          },
        },
      },
      window = {
        position = "right",
        width = 42,
        mappings = {
          ["l"] = "open",
          ["L"] = "open",
          ["<CR>"] = "open",
          ["<2-LeftMouse>"] = "open",

          ["h"] = "close_node",

          ["P"] = { "toggle_preview", config = { use_float = true } },
          ["F"] = "focus_preview",
          ["<Esc>"] = "cancel",

          ["s"] = "open_vsplit",
          ["S"] = "open_split",

          ["R"] = "refresh",
          ["a"] = { "add", config = { show_path = "none" } },
          ["A"] = "add_directory",
          ["d"] = "delete",
          ["r"] = "rename",
          ["y"] = "copy_to_clipboard",
          ["x"] = "cut_to_clipboard",
          ["p"] = "paste_from_clipboard",
          ["c"] = "copy",
          ["[b"] = "prev_source",
          ["]b"] = "next_source",

          ["z"] = "close_all_nodes",
          ["Z"] = "expand_all_nodes",

          ["<C-d>"] = { "scroll_preview", config = { direction = -4 } },
          ["<C-u>"] = { "scroll_preview", config = { direction = 4 } },

          ["q"] = "close_window",
          ["?"] = "show_help",
        },
      },
      filesystem = {
        window = {
          mappings = {
            ["H"] = "toggle_hidden",

            ["/"] = "fuzzy_finder",
            ["D"] = "fuzzy_finder_directory",
            ["#"] = "fuzzy_sorter",

            -- ["f"] = "filter_on_submit",
            -- ["F"] = "clear_filter",

            ["f"] = "telescope_find",
            ["g"] = "telescope_grep",

            ["<BS>"] = "navigate_up",
            ["."] = "set_root",

            ["[g"] = "prev_git_modified",
            ["]g"] = "next_git_modified",
          },
        },
        filtered_items = {
          visible = true,
        },
        commands = {
          telescope_find = function(state)
            exporter.find_or_grep("find", state)
          end,
          telescope_grep = function(state)
            exporter.find_or_grep("grep", state)
          end,
        },
        bind_to_cwd = false,
        use_libuv_file_watcher = true,
        follow_current_file = { enabled = true },
      },
    }
  end,
}

return M
