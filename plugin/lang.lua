-- lazydev: FileType lua trigger
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  once = true,
  callback = function()
    vim.pack.add({ "https://github.com/folke/lazydev.nvim" })
    require("lazydev").setup({
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "catppuccin" },
        { path = "snacks.nvim", words = { "Snacks" } },
      },
    })
  end,
})

-- render-markdown: FileType markdown/Avante trigger
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown" },
  once = true,
  callback = function()
    vim.pack.add({ "https://github.com/MeanderingProgrammer/render-markdown.nvim" })
    require("render-markdown").setup({
      heading = { enabled = false },
      file_types = { "markdown", "Avante" },
      code = {
        sign = false,
        width = "block",
        position = "right",
        min_width = 60,
        left_pad = 2,
        right_pad = 2,
        inline_pad = 1,
        language_pad = 1,
      },
      pipe_table = {
        preset = "round",
      },
    })

    vim.keymap.set(
      "n",
      "<leader>mr",
      "<Cmd>RenderMarkdown toggle<CR>",
      { desc = "Toggle render markdown" }
    )
  end,
})
