local ok, luadev = pcall(require, "lua-dev")

local fn = vim.fn

local opts = {
  cmd = { "lua-language-server" },
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          -- [fn.expand("$VIMRUNTIME")] = true,
          [fn.stdpath("config") .. "/lua"] = true,
        },
      },
    },
  },
}

if not ok then
  return opts
end

return luadev.setup({})
