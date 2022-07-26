local servers = {
  "bashls",
  "dockerls",
  "eslint",
  "gopls",
  "jsonls",
  "pylsp",
  "sqls",
  "stylelint_lsp",
  "sumneko_lua",
  -- "tailwindcss",
  "tsserver",
  "vimls",
  "volar",
  "yamlls",
}

require("nvim-lsp-installer").setup({
  ensure_installed = servers,
  automatic_installation = true,
})

for _, server in ipairs(servers) do
  require("mvim.lsp.manager").setup(server)
end

require("lsp_signature").setup({
  bind = true,
  fix_pos = true,
  hint_scheme = "Comment",
  handler_opts = { border = "none" },
})
