local M = {}

local api = vim.api

local function check_backspace()
  local line, col = unpack(api.nvim_win_get_cursor(0))
  return col ~= 0 and api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local kind_icons = {
  Class = " ",
  Color = " ",
  Constant = " ",
  Constructor = " ",
  Enum = "練",
  EnumMember = " ",
  Event = " ",
  Field = " ",
  File = "",
  Folder = " ",
  Function = " ",
  Interface = " ",
  Keyword = " ",
  Method = " ",
  Module = " ",
  Operator = " ",
  Property = " ",
  Reference = " ",
  Snippet = " ",
  Struct = " ",
  Text = " ",
  TypeParameter = " ",
  Unit = "塞",
  Value = " ",
  Variable = " ",
}

local source_names = {
  luasnip = "[Snippet]",
  nvim_lsp = "[LSP]",
  buffer = "[Buffer]",
  path = "[Path]",
  nvim_lua = "[NeoVim]",
}
local duplicates = {
  buffer = 1,
  path = 1,
  nvim_lsp = 0,
  luasnip = 1,
}

function M.setup()
  local cmp = require("cmp")
  local types = require("cmp.types")
  local luasnip = require("luasnip")
  local mapping = cmp.mapping

  cmp.setup({
    completion = {
      keyword_length = 1,
    },
    experimental = {
      ghost_text = true,
    },
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    sources = {
      { name = "nvim_lsp" },
      { name = "buffer" },
      { name = "path" },
      { name = "luasnip" },
      { name = "nvim_lua" },
    },
    formatting = {
      fields = { "kind", "abbr", "menu" },
      format = function(entry, vim_item)
        vim_item.kind = (kind_icons[vim_item.kind] or "") .. vim_item.kind
        vim_item.menu = source_names[entry.source.name] or entry.source.name
        vim_item.dup = duplicates[entry.source.name] or 0
        return vim_item
      end,
    },
    mapping = {
      ["<C-d>"] = mapping(mapping.scroll_docs(4), { "i" }),
      ["<C-u>"] = mapping(mapping.scroll_docs(-4), { "i" }),
      ["<C-e>"] = mapping.abort(),
      -- ["<C-Space>"] = cmp.mapping.complete(),
      ["<CR>"] = mapping.confirm({ select = false }),
      ["<Tab>"] = mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item({ behavior = types.cmp.SelectBehavior.Select })
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif check_backspace() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item({ behavior = types.cmp.SelectBehavior.Select })
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
    },
  })
end

return M
