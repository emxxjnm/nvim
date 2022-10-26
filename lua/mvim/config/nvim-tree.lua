local M = {}

function M.setup()
  local icons = mo.style.icons

  require("nvim-tree").setup({
    create_in_closed_folder = true,
    root_dirs = {
      ".git/",
      ".stylua.toml",
      "pyproject.toml",
    },
    prefer_startup_root = true,
    sync_root_with_cwd = true,
    reload_on_bufenter = false,
    respect_buf_cwd = true,
    select_prompts = true,
    view = {
      adaptive_size = true,
      width = 42,
      side = "right",
      mappings = {
        custom_only = true,
        list = {
          { key = { "l", "<CR>", "o", "<2-LeftMouse>" }, action = "edit" },
          { key = "<C-e>", action = "edit_in_place" },
          { key = "O", action = "edit_no_picker" },

          { key = { "<C-]>", "<2-RightMouse>" }, action = "cd" },

          { key = "s", action = "vsplit" },
          { key = "S", action = "split" },

          { key = "<C-t>", action = "tabnew" },

          { key = "<", action = "prev_sibling" },
          { key = ">", action = "next_sibling" },
          { key = "K", action = "first_sibling" },
          { key = "J", action = "last_sibling" },

          { key = "P", action = "parent_node" },
          { key = { "h", "<BS>" }, action = "close_node" },

          { key = "P", action = "preview" },

          { key = "H", action = "toggle_git_ignored" },
          { key = "D", action = "toggle_dotfiles" },
          { key = "U", action = "toggle_custom" },

          { key = "R", action = "refresh" },
          { key = "a", action = "create" },
          { key = "d", action = "remove" },
          { key = "D", action = "trash" },
          { key = "r", action = "rename" },
          { key = "x", action = "cut" },
          { key = "c", action = "copy" },
          { key = "p", action = "paste" },
          { key = "y", action = "copy_name" },
          { key = "Y", action = "copy_path" },
          { key = "gy", action = "copy_absolute_path" },

          { key = "<C-r>", action = "full_rename" },
          { key = "[d", action = "prev_diag_item" },
          { key = "]d", action = "next_diag_item" },

          { key = "[g", action = "prev_git_item" },
          { key = "]g", action = "next_git_item" },

          { key = "-", action = "dir_up" },

          { key = "f", action = "live_filter" },
          { key = "F", action = "clear_live_filter" },

          { key = "q", action = "close" },

          { key = "z", action = "expand_all" },
          { key = "Z", action = "collapse_all" },

          { key = "N", action = "search_node" },

          { key = ".", action = "run_file_command" },
          { key = "<C-k>", action = "toggle_file_info" },

          { key = "?", action = "toggle_help" },

          { key = "m", action = "toggle_mark" },
          { key = "bmv", action = "bulk_move" },
        },
      },
      float = {
        open_win_config = {
          border = "rounnded",
        },
      },
    },
    renderer = {
      highlight_opened_files = "name",
      highlight_git = true,
      root_folder_modifier = ":~",
      indent_markers = {
        enable = true,
      },
      icons = {
        show = {
          git = false,
        },
        glyphs = {
          default = icons.documents.file,
          symlink = icons.documents.file_symlink,
          bookmark = icons.misc.target,
          folder = {
            arrow_closed = icons.documents.collapsed,
            arrow_open = icons.documents.expanded,
            default = icons.documents.folder,
            open = icons.documents.folder_open,
            empty = icons.documents.empty_folder,
            empty_open = icons.documents.empty_folder_open,
            symlink = icons.documents.folder_symlink,
            symlink_open = icons.documents.folder_symlink,
          },
          git = {
            unstaged = icons.git.unstaged,
            staged = icons.git.staged,
            unmerged = icons.git.unstaged,
            renamed = icons.git.renamed,
            untracked = icons.git.untracked,
            deleted = icons.git.deleted,
            ignored = icons.git.ignored,
          },
        },
      },
      special_files = {
        "pyproject.toml",
        "Makefile",
        "README.md",
        "readme.md",
        "package.json",
      },
    },
    update_focused_file = {
      enable = true,
      update_root = true,
    },
    diagnostics = {
      enable = false,
      icons = {
        error = icons.diagnostics.error .. " ",
        warning = icons.diagnostics.warn .. " ",
        info = icons.diagnostics.info .. " ",
        hint = icons.diagnostics.hint .. " ",
      },
    },
    filters = {
      dotfiles = false,
      custom = {},
      exclude = { ".vscode" },
    },
    filesystem_watchers = {
      enable = true,
      debounce_delay = 100,
    },
    actions = {
      expand_all = {
        max_folder_discovery = 100,
        exclude = { ".git", "nodo_modules", "migrations" },
      },
      file_popup = {
        open_win_config = {
          border = mo.style.border.current,
        },
      },
      open_file = {
        quit_on_open = true,
        window_picker = {
          enable = true,
          chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
          exclude = {
            filetype = {
              "notify",
              "packer",
              "qf",
              "diff",
              "dap-relp",
            },
            buftype = { "nofile", "terminal", "help" },
          },
        },
      },
      remove_file = {
        close_window = false,
      },
    },
    trash = {
      cmd = "trash",
      require_confirm = true,
    },
    live_filter = {
      prefix = icons.misc.search .. " ",
      always_show_folders = true,
    },
  })

  vim.keymap.set(
    "n",
    "<leader>e",
    require("nvim-tree.api").tree.toggle,
    { desc = "nvim-tree: open or close the tree" }
  )
end

return M
