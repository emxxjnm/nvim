local M = {}

function M.setups()
  local luasnip = require("luasnip")
  local types = require("luasnip.util.types")

  luasnip.config.set_config({
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
  })

  -- <c-l> is selecting within a list of options.
  vim.keymap.set({ "s", "i" }, "<C-l>", function()
    if luasnip.choice_active() then
      luasnip.change_choice(1)
    end
  end, { silent = true, desc = "luasnip: Select within a list of options" })

  require("luasnip.loaders.from_vscode").lazy_load({
    paths = vim.fn.stdpath("config") .. "/snippets",
  })

  -- require("luasnip.loaders.from_vscode").lazy_load({ paths = "./snippets/textmate" })
end

return M
