local ok, luadev = pcall(require, "lua-dev")

local opts = {
  settings = {
    Lua = {
      format = { enable = false },
      diagnostics = {
        globals = { "vim", "packer_plugins" },
      },
    },
  },
}

if not ok then
  return opts
end

return luadev.setup({
  library = { pluings = { "plenary.nvim" } },
  lspconfig = opts,
})
