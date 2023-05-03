local U = require("mvim.utils")

local M = {
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
        prompt_prefix = I.misc.telescope .. " ",
        selection_caret = I.misc.fish .. " ",
        file_ignore_patterns = {
          "%.jpg",
          "%.jpeg",
          "%.png",
          "%.otf",
          "%.ttf",
          "^.git/",
          "^dist/",
          "^node_modules/",
          "^site-packages/",
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
          desc = "Prev todo comment",
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
              icon = I.todo.fix,
              color = "fix",
              alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
            },
            TODO = { icon = I.todo.todo, color = "todo" },
            HACK = { icon = I.todo.hack, color = "hack" },
            WARN = { icon = I.todo.warn, color = "warn", alt = { "WARNING", "XXX" } },
            PERF = { icon = I.todo.perf, color = "perf", alt = { "OPTIM" } },
            NOTE = { icon = I.todo.note, color = "note" },
            TEST = {
              icon = I.todo.test,
              color = "test",
              alt = { "PASSED", "FAILED" },
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
}

return M
