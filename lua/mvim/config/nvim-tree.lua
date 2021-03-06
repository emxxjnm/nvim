local M = {}

function M.setup()
  require("nvim-tree").setup({
    auto_reload_on_write = true,
    create_in_closed_folder = true,
    disable_netrw = false,
    hijack_cursor = false,
    hijack_netrw = true,
    hijack_unnamed_buffer_when_opening = false,
    ignore_buffer_on_setup = false,
    open_on_setup = false,
    open_on_setup_file = false,
    open_on_tab = false,
    sort_by = "name",
    root_dirs = {
      ".git/",
      ".stylua.toml",
      "pyproject.toml",
    },
    prefer_startup_root = true,
    update_cwd = false,
    reload_on_bufenter = false,
    respect_buf_cwd = false,
    view = {
      adaptive_size = false,
      centralize_selection = false,
      width = 38,
      height = 30,
      hide_root_folder = false,
      side = "right",
      preserve_window_proportions = false,
      number = false,
      relativenumber = false,
      signcolumn = "yes",
      mappings = {
        custom_only = false,
        list = {
          -- user mappings go here
          { key = { "l", "<CR>", "o" }, action = "edit" },
          { key = { "h" }, action = "close_node" },
          { key = "v", action = "vsplit" },
          { key = "O", action = "cd" },
          { key = "H", action = "toggle_git_ignored" },
          { key = "D", action = "toggle_dotfiles" },
        },
      },
    },
    renderer = {
      add_trailing = false,
      group_empty = false,
      highlight_git = false,
      full_name = false,
      highlight_opened_files = "icon",
      root_folder_modifier = ":~",
      indent_markers = {
        enable = false,
        icons = {
          corner = "└ ",
          edge = "│ ",
          none = "  ",
        },
      },
      icons = {
        webdev_colors = true,
        git_placement = "before",
        padding = " ",
        symlink_arrow = " ➛ ",
        show = {
          file = true,
          folder = true,
          folder_arrow = true,
          git = true,
        },
        glyphs = {
          default = "",
          symlink = "",
          folder = {
            arrow_closed = "",
            arrow_open = "",
            default = "",
            open = "",
            empty = "",
            empty_open = "",
            symlink = "",
            symlink_open = "",
          },
          git = {
            unstaged = "✗",
            staged = "✓",
            unmerged = "",
            renamed = "➜",
            untracked = "★",
            deleted = "",
            ignored = "◌",
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
    hijack_directories = {
      enable = true,
      auto_open = true,
    },
    update_focused_file = {
      enable = false,
      update_cwd = false,
      update_root = true,
      ignore_list = {},
    },
    ignore_ft_on_setup = {},
    system_open = {
      cmd = "",
      args = {},
    },
    diagnostics = {
      enable = false,
      show_on_dirs = false,
      icons = {
        error = "",
        warning = "",
        info = "",
        hint = "",
      },
    },
    filters = {
      dotfiles = false,
      custom = {},
      exclude = { ".vscode" },
    },
    filesystem_watchers = {
      enable = true,
      interval = 300,
    },
    git = {
      enable = true,
      ignore = true,
      show_on_dirs = true,
      timeout = 400,
    },
    actions = {
      use_system_clipboard = true,
      change_dir = {
        enable = true,
        global = false,
        restrict_above_cwd = false,
      },
      expand_all = {
        max_folder_discovery = 100,
        exclude = { ".git", "nodo_modules", "migrations" },
      },
      open_file = {
        quit_on_open = true,
        resize_window = true,
        window_picker = {
          enable = true,
          chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
          exclude = {
            filetype = {
              "notify",
              "packer",
              "qf",
              "diff",
              "fugitive",
              "fugitiveblame",
            },
            buftype = { "nofile", "terminal", "help" },
          },
        },
      },
      remove_file = {
        close_window = true,
      },
    },
    trash = {
      cmd = "trash",
      require_confirm = true,
    },
    live_filter = {
      prefix = " ",
      always_show_folders = true,
    },
    log = {
      enable = false,
      truncate = false,
      types = {
        all = false,
        config = false,
        copy_paste = false,
        diagnostics = false,
        git = false,
        profile = false,
        watcher = false,
      },
    },
  })
end

return M
