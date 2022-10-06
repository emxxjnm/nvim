local M = {}

function M.setup()
  vim.g.neo_tree_remove_legacy_commands = 1
  local icons = mo.style.icons

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
    -- use_default_mappings = false,
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
    },
    nesting_rules = {},
    filesystem = {
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = true,
        hide_hidden = true,
        hide_by_name = {
          --"node_modules"
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
