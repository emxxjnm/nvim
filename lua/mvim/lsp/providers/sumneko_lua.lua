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
          [fn.expand("$VIMRUNTIME/lua")] = true,
          [fn.stdpath("config") .. "/lua"] = true,
        },
      },
    },
  },
}

return opts
