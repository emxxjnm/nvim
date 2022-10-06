local M = {}

function M.setups()
  local luasnip = require("luasnip")
  local extras = require("luasnip.extras")
  local types = require("luasnip.util.types")
  local fmt = require("luasnip.extras.fmt").fmt

  luasnip.config.set_config({
    history = false,
    region_check_events = "CursorMoved,CursorHold,InsertEnter",
    delete_check_events = "InsertLeave",
    ext_opts = {
      [types.choiceNode] = {
        active = {
          virt_text = {
            { mo.style.icons.misc.snow .. " ", "Type" },
          },
        },
      },
    },
    enable_autosnippets = true,
    snip_env = {
      fmt = fmt,
      m = extras.match,
      t = luasnip.text_node,
      f = luasnip.function_node,
      c = luasnip.choice_node,
      d = luasnip.dynamic_node,
      i = luasnip.insert_node,
      l = extras.lambda,
      snippet = luasnip.snippet,
    },
  })

  -- <c-l> is selecting within a list of options.
  vim.keymap.set({ "s", "i" }, "<c-l>", function()
    if luasnip.choice_active() then
      luasnip.change_choice(1)
    end
  end, { silent = true, desc = "select within a list of options" })

  require("luasnip.loaders.from_vscode").lazy_load({
    paths = vim.fn.stdpath("config") .. "/snippets",
  })

  require("luasnip.loaders.from_vscode").lazy_load({ paths = "./snippets/textmate" })
end

return M
