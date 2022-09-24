local actions = require("telescope.actions")
local layout_actions = require("telescope.actions.layout")

local M = {}

function M.setup()
  require("telescope").setup({
    defaults = {
      prompt_prefix = " ",
      selection_caret = " ",
      file_ignore_patterns = {
        "node_modules/",
        ".git/",
        "dist/",
        "package-lock.json",
        "yarn.lock",
        "pnpm-lock.yaml",
        "__pycache__/",
        "migrations/",
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
          ["<C-l>"] = layout_actions.toggle_preview,
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
end

return M
