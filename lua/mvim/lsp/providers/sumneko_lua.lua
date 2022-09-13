local dev_opts = {
  library = {
    vimruntime = true,
    types = true,
    plugins = { "plenary.nvim" },
  },
  override = nil,
}
local ok, luadev = pcall(require, "lua-dev")

if ok then
  luadev.setup(dev_opts)
end

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

return opts
