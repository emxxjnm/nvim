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

for _, server in ipairs(servers) do
  require("mvim.lsp.manager").setup(server)
end
