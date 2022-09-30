local M = {}

function M.setup()
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
      width = 38,
      side = "right",
      mappings = {
        custom_only = false,
        list = {
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
      highlight_opened_files = "name",
      root_folder_modifier = ":~",
      indent_markers = {
        enable = true,
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
        error = "",
        warning = "",
        info = "",
        hint = "",
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
      prefix = " ",
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
