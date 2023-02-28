local icons = mo.styles.icons
local U = require("mvim.utils")

local M = {
  -- file explorer
  {
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
      sources = { "filesystem", "buffers", "git_status" },
      source_selector = {
        winbar = true,
        separator = "",
        content_layout = "center",
        tab_labels = {
          filesystem = icons.documents.root_folder .. " Files",
          buffers = icons.misc.buffer .. " Buffers",
          git_status = icons.git.source_control .. " Git",
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
          indent_marker = icons.documents.indent,
          last_indent_marker = icons.documents.last_indent,
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
        modified = { symbol = icons.misc.dot },
        name = { trailing_slash = false, use_git_status_colors = true },
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
  },

  -- fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<Cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>fg", "<Cmd>Telescope live_grep_args<CR>", desc = "Find in files (Grep)" },
      { "<leader>fw", "<Cmd>Telescope grep_string<CR>", desc = "Find word" },
      { "<leader>fr", "<Cmd>Telescope oldfiles<CR>", desc = "Recent files" },
      { "<leader>fp", "<Cmd>Telescope projects<CR>", desc = "Recent projects" },
      { "<leader>fc", "<Cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Fuzzy search" },
      { "<leader>fb", "<Cmd>Telescope buffers<CR>", desc = "List buffers" },
      { "<leader>fd", "<Cmd>Telescope diagnostics<CR>", desc = "List diagnostics" },
      { "<leader>fs", U.lsp_symbols("document"), desc = "Goto symbol" },
      { "<leader>fS", U.lsp_symbols("workspace"), desc = "Goto symbol (Workspace)" },
      { "<leader>ft", "<Cmd>Telescope todo-comments todo<CR>", desc = "List todo" },
      { "<leader>fR", "<Cmd>Telescope resume<CR>", desc = "Resume" },
    },
    opts = function()
      local actions = require("telescope.actions")
      local layout_actions = require("telescope.actions.layout")

      return {
        defaults = {
          prompt_prefix = mo.styles.icons.misc.telescope .. " ",
          selection_caret = mo.styles.icons.misc.fish .. " ",
          file_ignore_patterns = {
            ".git/",
            "^dist/",
            "^node_modules/",
            "^__pycache__/",
            "^migrations/",
            ".mypy_cache/",
            "package-lock.json",
            "yarn.lock",
            "pnpm-lock.yaml",
            ".DS_Store",
          },
          layout_config = {
            height = 0.9,
            width = 0.9,
            horizontal = {
              preview_cutoff = 120,
              preview_width = 0.6,
            },
            vertical = {
              preview_cutoff = 120,
              preview_height = 0.7,
            },
          },
          path_display = {
            truncate = 3,
          },
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-p>"] = actions.cycle_history_prev,
              ["<C-n>"] = actions.cycle_history_next,
              ["<Esc>"] = actions.close,
              ["<CR>"] = actions.select_default,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<Tab>"] = actions.toggle_selection + actions.move_selection_next,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_previous,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<C-e>"] = layout_actions.toggle_preview,
            },
          },
        },
        pickers = {
          find_files = {
            find_command = { "fd" },
            hidden = true,
          },
          buffers = {
            theme = "dropdown",
            previewer = false,
            sort_mru = true,
            sort_lastused = true,
            ignore_current_buffer = true,
            mappings = {
              i = { ["<C-x>"] = actions.delete_buffer },
            },
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)

      telescope.load_extension("fzf")
      telescope.load_extension("projects")
      telescope.load_extension("live_grep_args")
    end,
    dependencies = {
      "nvim-telescope/telescope-live-grep-args.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
          {
            "[t",
            function()
              require("todo-comments").jump_prev()
            end,
            desc = "Previous todo comment",
          },
          {
            "]t",
            function()
              require("todo-comments").jump_next()
            end,
            desc = "Next todo comment",
          },
        },
        opts = function()
          local colors = require("catppuccin.palettes").get_palette()

          return {
            keywords = {
              FIX = {
                icon = icons.misc.tool,
                color = "fix",
                alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
              },
              TODO = { icon = icons.misc.tag, color = "todo" },
              HACK = { icon = icons.misc.flame, color = "hack" },
              WARN = { icon = icons.misc.bell, color = "warn", alt = { "WARNING", "XXX" } },
              PERF = {
                icon = icons.misc.rocket,
                color = "perf",
                alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" },
              },
              NOTE = { icon = icons.misc.comment, color = "note" },
              TEST = {
                icon = icons.misc.tower,
                color = "test",
                alt = { "TESTING", "PASSED", "FAILED" },
              },
            },
            highlight = {
              before = "",
              keyword = "wide_fg",
              after = "",
            },
            colors = {
              fix = { colors.red },
              todo = { colors.green },
              hack = { colors.peach },
              warn = { colors.yellow },
              perf = { colors.mauve },
              note = { colors.blue },
              test = { colors.sky },
            },
          }
        end,
      },
      {
        "ahmedkhalf/project.nvim",
        config = function()
          require("project_nvim").setup({
            manual_mode = false,
            patterns = { ".git", "pyproject.toml", "go.mod", "Makefile" },
            show_hidden = true,
          })
        end,
      },
    },
  },

  -- highlight
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      { "<Tab>", mode = { "v" }, desc = "Increment selection" },
      { "<BS>", mode = { "n", "v" }, desc = "Schrink selection" },
      { "<CR>", mode = { "n", "v" }, desc = "Increment selection" },
    },
    opts = {
      ensure_installed = {
        "bash",
        "css",
        "dockerfile",
        "dot",
        "gitignore",
        "go",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "python",
        "scss",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vue",
        "yaml",
      },
      highlight = { enable = true },
      indent = { enable = true, disable = { "yaml", "python" } },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<CR>", -- normal mode
          node_incremental = "<Tab>", -- visual mode
          scope_incremental = "<CR>", -- visual mode
          node_decremental = "<BS>", -- visual mode
        },
      },
      context_commentstring = { enable = true, enable_autocmd = false },
      textobjects = {
        select = {
          enable = true,
          keymaps = {
            ["ac"] = { query = "@function.outer", desc = "TS: all class" },
            ["ic"] = { query = "@function.inner", desc = "TS: inner class" },
            ["af"] = { query = "@function.outer", desc = "TS: all function" },
            ["if"] = { query = "@function.inner", desc = "TS: inner function" },
            ["aL"] = { query = "@assignment.lhs", desc = "TS: assignment lhs" },
            ["aR"] = { query = "@assignment.rhs", desc = "TS: assignment rhs" },
          },
        },
        move = {
          enable = true,
          goto_next_start = {
            ["]c"] = { query = "@class.outer", desc = "TS: Next class start" },
            ["]f"] = { query = "@function.outer", desc = "TS: Next function start" },
          },
          goto_previous_start = {
            ["[c"] = { query = "@class.outer", desc = "TS: Prev class start" },
            ["[f"] = { query = "@function.outer", desc = "TS: Prev function start" },
          },
        },
      },
      autotag = {
        enable = true,
        filetypes = {
          "vue",
          "tsx",
          "jsx",
          "xml",
          "html",
          "javascript",
          "typescript",
          "javascriptreact",
          "typescriptreact",
        },
      },
      matchup = { enable = true },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
    dependencies = {
      "windwp/nvim-ts-autotag",
      "nvim-treesitter/nvim-treesitter-textobjects",
      "JoosepAlviste/nvim-ts-context-commentstring",
      {
        "andymass/vim-matchup",
        keys = {
          { "[%", desc = "matchup: Move to prev" },
          { "]%", desc = "matchup: Move to next" },
        },
        config = function()
          vim.g.matchup_matchparen_offscreen = {
            method = "popup",
            fullwidth = true,
          }
        end,
      },
      {
        "windwp/nvim-autopairs",
        dependencies = { "nvim-cmp" },
        opts = {
          check_ts = true,
          ignored_next_char = string.gsub([[ [%w%%%'%[%"%.] ]], "%s+", ""),
          fast_wrap = { map = "<M-e>" },
        },
        config = function(_, opts)
          require("nvim-autopairs").setup(opts)

          local cmp_autopairs = require("nvim-autopairs.completion.cmp")
          require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },
    },
  },
}

return M
