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
  deactivate = function()
    vim.cmd([[Neotree close]])
  end,
  init = function()
    vim.g.neo_tree_remove_legacy_commands = 1
    if vim.fn.argc() == 1 then
      local stat = vim.loop.fs_stat(vim.fn.argv(0))
      if stat and stat.type == "directory" then
        require("neo-tree")
      end
    end
  end,
  opts = {
    source_selector = {
      winbar = true,
      separator = "",
      content_layout = "center",
      truncation_character = I.misc.ellipsis,
      sources = {
        { source = "filesystem", display_name = I.documents.root_folder .. " Files" },
        { source = "buffers", display_name = I.misc.buffer .. " Buffers" },
        { source = "git_status", display_name = I.git.git .. " Git" },
      },
    },
    close_if_last_window = true,
    use_default_mappings = false,
    popup_border_style = "rounded", -- no support "none"
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
        indent_marker = I.indent.solid,
        last_indent_marker = I.indent.last,
        with_expanders = true,
        expander_collapsed = I.documents.collapsed,
        expander_expanded = I.documents.expanded,
      },
      icon = {
        folder_closed = I.documents.folder,
        folder_open = I.documents.folder_open,
        folder_empty = I.documents.empty_folder,
        default = I.documents.file,
      },
      modified = { symbol = I.documents.modified },
      name = {
        trailing_slash = false,
        highlight_opened_files = true,
        use_git_status_colors = true,
      },
      git_status = {
        symbols = {
          added = I.git.added,
          modified = I.git.modified,
          deleted = I.git.deleted,
          renamed = I.git.renamed,

          untracked = I.git.untracked,
          ignored = I.git.ignored,
          unstaged = I.git.unstaged,
          staged = I.git.staged,
          conflict = I.git.conflict,
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
        ["<Esc>"] = "revert_preview",

        ["s"] = "open_vsplit",
        ["S"] = "open_split",

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
    filesystem = {
      window = {
        mappings = {
          ["H"] = "toggle_hidden",

          ["/"] = "fuzzy_finder",
          ["D"] = "fuzzy_finder_directory",
          ["#"] = "fuzzy_sorter",

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
      },
      follow_current_file = true,
    },
  },
}

return M
