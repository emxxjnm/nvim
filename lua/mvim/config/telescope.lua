local actions = require("telescope.actions")
local layout_actions = require("telescope.actions.layout")

local M = {}

function M.setup()
  local telescope = require("telescope")
  telescope.setup({
    defaults = {
      prompt_prefix = mo.style.icons.misc.telescope .. " ",
      selection_caret = mo.style.icons.misc.selection .. " ",
      file_ignore_patterns = {
        "node_modules/",
        ".git/",
        "dist/",
        "package-lock.json",
        "yarn.lock",
        "pnpm-lock.yaml",
        "__pycache__/",
        "migrations/",
        ".mypy_cache",
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
    desc = "telescope: Find files in your current working directory",
  })

  map("n", "<leader>fg", telescope.extensions.live_grep_args.live_grep_args, {
    silent = true,
    desc = "telescope: Search for a string in your current working directory",
  })

  map("n", "<leader>fr", builtin.oldfiles, {
    silent = true,
    desc = "telescope: Lists previously open files",
  })

  map("n", "<leader>fp", telescope.extensions.projects.projects, {
    silent = true,
    desc = "telescope: Lists previously open projects",
  })

  map("n", "<leader>fb", builtin.buffers, {
    silent = true,
    desc = "telescope: Lists open buffers in current neovim instance",
  })

  map("n", "<leader>fc", builtin.current_buffer_fuzzy_find, {
    silent = true,
    desc = "telescope: Live fuzzy search inside of the currently open buffer",
  })

  map("n", "<leader>fd", builtin.diagnostics, {
    silent = true,
    desc = "telescope: Lists Diagnostics for all open buffers",
  })

  map("n", "<leader>fs", builtin.lsp_document_symbols, {
    silent = true,
    desc = "telescope: Lists LSP document symbols in the current buffer",
  })

  map("n", "<leader>f?", builtin.help_tags, {
    silent = true,
    desc = "telescope: Lists available help tags",
  })
end

return M
