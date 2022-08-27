local ok, _ = mo.require("mason")
if not ok then
  return
end

local servers = {
  "bashls",
  "dockerls",
  "cssls",
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
