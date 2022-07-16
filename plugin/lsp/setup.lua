require("nvim-lsp-installer").setup({
  automatic_installation = true,
})

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
  require("mvim.lsp.manager").setup(server, require("mvim.lsp.config").get_common_opts())
end

require("lsp_signature").setup({
  bind = true,
  fix_pos = true,
  hint_scheme = "Comment",
  handler_opts = { border = "none" },
})
