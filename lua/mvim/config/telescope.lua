local actions = require("telescope.actions")
local layout_actions = require("telescope.actions.layout")

local M = {}

function M.setup()
  local telescope = require("telescope")
  telescope.setup({
    defaults = {
      prompt_prefix = mo.style.icons.misc.telescope .. " ",
      selection_caret = mo.style.icons.misc.fish .. " ",
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
  })

  local builtin = require("telescope.builtin")
  local map = vim.keymap.set

  map("n", "<leader>ff", builtin.find_files, {
    silent = true,
    desc = "Find files in current project",
  })

  map("n", "<leader>fg", telescope.extensions.live_grep_args.live_grep_args, {
    silent = true,
    desc = "Search for a string in project",
  })

  map("n", "<leader>fr", builtin.oldfiles, {
    silent = true,
    desc = "Lists previously open files",
  })

  map("n", "<leader>fp", telescope.extensions.projects.projects, {
    silent = true,
    desc = "Lists previously open projects",
  })

  map("n", "<leader>fb", builtin.buffers, {
    silent = true,
    desc = "Lists open buffers",
  })

  map("n", "<leader>fc", builtin.current_buffer_fuzzy_find, {
    silent = true,
    desc = "Live fuzzy search",
  })

  map("n", "<leader>fd", builtin.diagnostics, {
    silent = true,
    desc = "Lists Diagnostics",
  })

  map("n", "<leader>fs", builtin.lsp_document_symbols, {
    silent = true,
    desc = "Lists LSP document symbols",
  })

  map("n", "<leader>ft", telescope.extensions["todo-comments"].todo, {
    silent = true,
    desc = "Search all project todos",
  })

  map("n", "<leader>fk", builtin.keymaps, {
    silent = true,
    desc = "Lists normal mode keymappings",
  })

  map("n", "<leader>f?", builtin.help_tags, {
    silent = true,
    desc = "Lists available help tags",
  })
end

return M
