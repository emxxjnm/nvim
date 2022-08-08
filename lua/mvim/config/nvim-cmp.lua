local M = {}

local api = vim.api

local function check_backspace()
  local line, col = unpack(api.nvim_win_get_cursor(0))
  return col ~= 0
    and api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
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
  luasnip = "(Snippet)",
  nvim_lsp = "(LSP)",
  buffer = "(Buffer)",
  path = "(Path)",
  cmdline = "(Cmd)",
}

function M.setup()
  local cmp = require("cmp")
  local luasnip = require("luasnip")

  cmp.setup({
    completion = {
      keyword_length = 2,
    },
    experimental = {
      ghost_text = true,
    },
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "path" },
    }, {
      {
        name = "buffer",
        option = {
          get_bufnrs = function()
            local bufs = {}
            for _, win in ipairs(api.nvim_list_wins()) do
              bufs[api.nvim_win_get_buf(win)] = true
            end
            return vim.tbl_keys(bufs)
          end,
        },
      },
      -- { name = 'spell' },
    }),
    formatting = {
      fields = { "kind", "abbr", "menu" },
      format = function(entry, vim_item)
        local MAX = math.floor(vim.o.columns * 0.5)
        if #vim_item.abbr >= MAX then
          vim_item.abbr = vim_item.abbr:sub(1, MAX) .. "…"
        end
        vim_item.kind = (kind_icons[vim_item.kind] or "") .. vim_item.kind
        vim_item.menu = source_names[entry.source.name] or entry.source.name
        return vim_item
      end,
    },
    mapping = {
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif check_backspace() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s", "c" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s", "c" }),
      ["<CR>"] = cmp.mapping(cmp.mapping.confirm({ select = false }), { "i", "c" }),
      ["<C-e>"] = { i = cmp.mapping.abort(), c = cmp.mapping.close() },
      ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-8), { "i", "c" }),
      ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(8), { "i", "c" }),
      -- ["<C-c>"] = cmp.mapping.complete(),
      ["<Down>"] = {
        i = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
      },
      ["<Up>"] = {
        i = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
      },
    },
  })

  local search_sources = {
    sources = cmp.config.sources({
      { name = "buffer" },
    }),
  }

  cmp.setup.cmdline("/", search_sources)
  cmp.setup.cmdline("?", search_sources)
  cmp.setup.cmdline(":", {
    sources = cmp.config.sources({
      { name = "cmdline", keyword_pattern = [=[[^[:blank:]\!]*]=] },
      { name = "path" },
    }),
  })
end

return M
