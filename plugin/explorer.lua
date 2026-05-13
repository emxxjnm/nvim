local load_neo_tree = Mo.once(function()
  vim.pack.add({
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/MunifTanjim/nui.nvim",
    "https://github.com/nvim-tree/nvim-web-devicons",
    "https://github.com/nvim-neo-tree/neo-tree.nvim",
  })

  local events = require("neo-tree.events")
  local function on_move(data)
    Snacks.rename.on_rename_file(data.source, data.destination)
  end

  require("neo-tree").setup({
    source_selector = {
      winbar = true,
      separator = "",
      content_layout = "center",
      truncation_character = "",
      sources = {
        { source = "filesystem", display_name = "󱉭 Files" },
        { source = "buffers", display_name = " Buffers" },
        { source = "git_status", display_name = "󰊢 Git" },
      },
    },
    close_if_last_window = true,
    use_default_mappings = false,
    popup_border_style = "rounded",
    event_handlers = {
      { event = events.FILE_MOVED, handler = on_move },
      { event = events.FILE_RENAMED, handler = on_move },
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
          added = "󰐖 ",
          modified = "󱗜 ",
          deleted = "󰍵 ",
          renamed = "󰜵 ",
          ignored = "󰿠 ",
          untracked = "󰩳 ",
          unstaged = "󰆟 ",
          staged = "󰄲 ",
          conflict = "󰅗 ",
        },
      },
    },
    commands = {
      copy_filename = function(state)
        local target = vim.fn.fnamemodify(state.tree:get_node():get_id(), ":t")
        vim.fn.setreg("+", target, "c")
        vim.notify("filename copied", vim.log.levels.INFO)
      end,
      copy_path = function(state)
        local target = state.tree:get_node():get_id()
        vim.fn.setreg("+", target, "c")
        vim.notify("path copied", vim.log.levels.INFO)
      end,
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
        ["|"] = "open_vsplit",
        ["-"] = "open_split",
        ["R"] = "refresh",
        ["a"] = { "add", config = { show_path = "relative", insert_as = "sibling" } },
        ["A"] = { "add", config = { show_path = "relative", insert_as = "child" } },
        ["d"] = "delete",
        ["r"] = "rename",
        ["y"] = "copy_to_clipboard",
        ["x"] = "cut_to_clipboard",
        ["p"] = "paste_from_clipboard",
        ["cf"] = "copy_filename",
        ["cp"] = "copy_path",
        ["[b"] = "prev_source",
        ["]b"] = "next_source",
        ["z"] = "close_all_nodes",
        ["Z"] = "expand_all_nodes",
        ["<C-d>"] = { "scroll_preview", config = { direction = -4 } },
        ["<C-u>"] = { "scroll_preview", config = { direction = 4 } },
        ["e"] = "toggle_auto_expand_width",
        ["q"] = "close_window",
        ["?"] = "show_help",
      },
    },
    filesystem = {
      window = {
        mappings = {
          ["."] = "toggle_hidden",
          ["/"] = "fuzzy_finder",
          ["D"] = "fuzzy_finder_directory",
          ["#"] = "fuzzy_sorter",
          ["<BS>"] = "navigate_up",
          ["[g"] = "prev_git_modified",
          ["]g"] = "next_git_modified",
        },
        fuzzy_finder_mappings = {
          ["<down>"] = "move_cursor_down",
          ["<up>"] = "move_cursor_up",
          ["<Esc>"] = "close",
          {
            n = {
              ["j"] = "move_cursor_down",
              ["k"] = "move_cursor_up",
              ["<esc>"] = "close",
            },
          },
        },
      },
      filtered_items = {
        visible = true,
        never_show = {
          ".DS_Store",
          "thumbs.db",
          ".direnv",
          ".venv",
          "__pycache__",
          "node_modules",
        },
      },
      bind_to_cwd = false,
      use_libuv_file_watcher = true,
      follow_current_file = { enabled = true },
    },
  })

  vim.api.nvim_create_autocmd("TermClose", {
    pattern = "*lazygit",
    callback = function()
      if package.loaded["neo-tree.sources.git_status"] then
        require("neo-tree.sources.git_status").refresh()
      end
    end,
  })
end)

-- Directory argument detection
if vim.fn.argc(-1) == 1 then
  local stat = vim.uv.fs_stat(vim.api.nvim_buf_get_name(0))
  if stat and stat.type == "directory" then
    load_neo_tree()
    require("neo-tree.command").execute({ reveal = true })
  end
end

-- Keymap trigger
vim.keymap.set("n", "<C-n>", function()
  load_neo_tree()
  require("neo-tree.command").execute({ toggle = true, reveal = true })
end, { desc = "Explorer(NeoTree)" })
