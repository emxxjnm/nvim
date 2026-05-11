vim.pack.add({ { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" } })

local ts = require("nvim-treesitter")

local ensure_installed = {
  "bash",
  "css",
  "dockerfile",
  "dot",
  "gitignore",
  "go",
  "gomod",
  "gowork",
  "gosum",
  "html",
  "javascript",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "nix",
  "nu",
  "python",
  "regex",
  "ron",
  "rust",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "vue",
  "yaml",
}

vim.schedule(function()
  local installed = {}
  for _, lang in ipairs(ts.get_installed()) do
    installed[lang] = true
  end
  local install = vim.tbl_filter(function(lang)
    return not installed[lang]
  end, ensure_installed)
  if #install > 0 then
    ts.install(install, { summary = true })
  end
end)

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("mvim_treesitter", { clear = true }),
  callback = function()
    pcall(vim.treesitter.start)
  end,
  desc = "Start treesitter for specific filetypes",
})

-- autotag: FileType trigger for web filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "vue", "typescriptreact", "javascriptreact", "html" },
  once = true,
  callback = function()
    vim.pack.add({ "https://github.com/windwp/nvim-ts-autotag" })
    require("nvim-ts-autotag").setup({})
  end,
})
