local ok, luadev = pcall(require, "lua-dev")

local opts = {
  settings = {
    Lua = {
      format = { enable = false },
      telemetry = {
        enable = false,
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
