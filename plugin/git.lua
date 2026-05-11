vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("mvim_gitsigns", { clear = true }),
  once = true,
  callback = function()
    vim.pack.add({ "https://github.com/lewis6991/gitsigns.nvim" })

    require("gitsigns").setup({
      signs = {
        add = { text = "┃" },
        change = { text = "┃" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "┃" },
        untracked = { text = "┃" },
      },
      signs_staged = {
        add = { text = "┃" },
        change = { text = "┃" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "┃" },
        untracked = { text = "┃" },
      },
      current_line_blame = true,
      current_line_blame_formatter = " <author>, <author_time> · <summary> ",
      preview_config = { border = Mo.C.border },
      on_attach = function(bufnr)
        local gs = require("gitsigns")

        local function keymap(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        -- stylua: ignore start
        keymap("n", "[g", function() gs.nav_hunk("prev") end, "Prev git hunk")
        keymap("n", "]g", function() gs.nav_hunk("next") end, "Next git hunk")
        keymap("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
        keymap("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Blame line")
        keymap("n", "<leader>gd", gs.diffthis, "Diff this")
        keymap({ "o", "x" }, "ig", ":<C-U>Gitsigns select_hunk<CR>", "Select git hunk")
        -- stylua: ignore end
      end,
    })
  end,
})
