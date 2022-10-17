local M = {}

function M.setup()
  require("gitsigns").setup({
    signs = {
      add = {
        hl = "GitSignsAdd",
        text = "│",
        numhl = "GitSignsAddNr",
        linehl = "GitSignsAddLn",
      },
      change = {
        hl = "GitSignsChange",
        text = "│",
        numhl = "GitSignsChangeNr",
        linehl = "GitSignsChangeLn",
      },
      delete = {
        hl = "GitSignsDelete",
        text = "_",
        numhl = "GitSignsDeleteNr",
        linehl = "GitSignsDeleteLn",
      },
      topdelete = {
        hl = "GitSignsDelete",
        text = "‾",
        numhl = "GitSignsDeleteNr",
        linehl = "GitSignsDeleteLn",
      },
      changedelete = {
        hl = "GitSignsChange",
        text = "~",
        numhl = "GitSignsChangeNr",
        linehl = "GitSignsChangeLn",
      },
    },
    current_line_blame = true,
    current_line_blame_opts = {
      delay = 800,
      virt_text = true,
      virt_text_pos = "eol",
      virt_text_priority = 100,
      ignore_whitespace = false,
    },
    current_line_blame_formatter = "<author>, <author_time> · <summary>",
    update_debounce = 300,
    preview_config = {
      border = mo.style.border.current,
    },
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function set_keymap(mode, lhs, rhs, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, lhs, rhs, opts)
      end

      -- Navigation
      set_keymap("n", "[g", function()
        if vim.wo.diff then
          return "[g"
        end
        vim.schedule(function()
          gs.prev_hunk({ navigation_message = false })
        end)
        return "<Ignore>"
      end, { expr = true, desc = "Git: Go to prev hunk" })

      set_keymap("n", "]g", function()
        if vim.wo.diff then
          return "]g"
        end
        vim.schedule(function()
          gs.next_hunk({ navigation_message = false })
        end)
        return "<Ignore>"
      end, { expr = true, desc = "Git: Go to next hunk" })

      -- Actions
      set_keymap("n", "<leader>gp", gs.preview_hunk, { silent = true, desc = "Git: Preview hunk" })

      -- Text object
      -- set_keymap({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
    end,
  })
end

return M
