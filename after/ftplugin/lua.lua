require("mvim.lsp.manager").setup("sumneko_lua")

local null_ls = require("null-ls")
-- use ftplugin
local service = require("mvim.lsp.service")
local helper = require("null-ls.helpers")
local utils = require("null-ls.utils")

service.register_sources({
  { command = "stylua" },
}, null_ls.methods.FORMATTING)
service.register_sources({
  {
    command = "luacheck",
    cwd = helper.cache.by_bufnr(function(params)
      return utils.root_pattern(".luacheckrc")(params.bufname)
    end),
    runtime_condition = helper.cache.by_bufnr(function(params)
      return utils.path.exists(utils.path.join(params.root, ".luacheckrc"))
    end),
  },
}, null_ls.methods.DIAGNOSTICS)
