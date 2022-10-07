local M = {}

function M.setup()
  local icons = mo.style.icons
  vim.g.neo_tree_remove_legacy_commands = 1

  require("neo-tree").setup({
    sources = {
      "filesystem",
      "buffers",
      "git_status",
    },
    source_selector = {
      winbar = true,
    },
    close_if_last_window = true,
    use_default_mappings = false,
    popup_border_style = "rounded",
    event_handlers = {
      {
        event = "file_opened",
        handler = function()
          require("neo-tree").close_all()
        end,
      },
    },
    default_component_configs = {
      indent = {
        with_markers = true,
        indent_marker = "│",
        last_indent_marker = "└",
        with_expanders = true,
        expander_collapsed = icons.documents.collapsed,
        expander_expanded = icons.documents.expanded,
      },
      icon = {
        folder_closed = icons.documents.folder,
        folder_open = icons.documents.folder_open,
        folder_empty = icons.documents.empty_folder,
        default = icons.documents.file,
      },
      modified = {
        symbol = icons.misc.circle,
      },
      name = {
        trailing_slash = false,
        use_git_status_colors = true,
      },
      git_status = {
        symbols = {
          added = icons.git.added,
          modified = icons.git.modified,
          deleted = icons.git.deleted,
          renamed = icons.git.renamed,
          untracked = icons.git.untracked,
          ignored = icons.git.ignored,
          unstaged = icons.git.unstaged,
          staged = icons.git.staged,
          conflict = icons.git.conflict,
        },
      },
    },
    window = {
      position = "right",
      mappings = {
        ["l"] = "open",
        ["L"] = "open",
        ["<CR>"] = "open",
        ["<2-LeftMouse>"] = "open",

        ["h"] = "close_node",

        ["P"] = { "toggle_preview", config = { use_float = true } },
        ["<Esc>"] = "revert_preview",

        ["s"] = "open_split",
        ["S"] = "open_vsplit",

        ["R"] = "refresh",
        ["a"] = { "add", config = { show_path = "none" } },
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

        ["q"] = "close_window",
        ["?"] = "show_help",
      },
    },
    nesting_rules = {},
    filesystem = {
      window = {
        mappings = {
          ["H"] = "toggle_hidden",

          ["/"] = "fuzzy_finder",
          ["D"] = "fuzzy_finder_directory",

          ["f"] = "filter_on_submit",
          ["F"] = "clear_filter",

          ["<BS>"] = "navigate_up",
          ["."] = "set_root",

          ["[g"] = "prev_git_modified",
          ["]g"] = "next_git_modified",
        },
      },
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = true,
        hide_hidden = true,
        hide_by_name = {
          -- "node_modules",
        },
        hide_by_pattern = {
          --"*.meta",
          --"*/src/*/tsconfig.json",
        },
        always_show = {
          ".vim",
          ".vscode",
        },
        never_show = {
          ".DS_Store",
          ".dmypy",
          "__pycache__",
          ".mypy_cache",
        },
        never_show_by_pattern = {},
      },
      follow_current_file = true,
      hijack_netrw_behavior = "open_current",
      use_libuv_file_watcher = true,
    },
  })
  vim.keymap.set("n", "<C-n>", "<Cmd>Neotree toggle reveal<CR>")
end

return M
