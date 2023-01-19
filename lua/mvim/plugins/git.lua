local M = {
  "lewis6991/gitsigns.nvim",
  event = "BufReadPre",
  opts = {
    signs = {
      add = { text = "│" }, -- alternatives: █
      change = { text = "│" }, -- alternatives: ░ ⣿
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
      untracked = { text = "┆" },
    },
    current_line_blame = true,
    current_line_blame_opts = { virt_text_priority = 100 },
    current_line_blame_formatter = "<author>, <author_time> · <summary>",
    preview_config = { border = mo.styles.border },
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function keymap(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
      end

      -- Navigation
      keymap("n", "[g", gs.prev_hunk, "Git: Prev hunk")
      keymap("n", "]g", gs.next_hunk, "Git: Next hunk")
      -- Actions
      keymap("n", "<leader>gp", gs.preview_hunk, "Git: Preview hunk")
      -- Text object
      keymap({ "o", "x" }, "ig", ":<C-U>Gitsigns select_hunk<CR>", "Git: Select hunk")
    end,
  },
}

return M
