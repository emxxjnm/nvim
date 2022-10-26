local M = {}

local api = vim.api
local fmt = string.format
local icons = mo.style.icons

local function check_backspace()
  local line, col = unpack(api.nvim_win_get_cursor(0))
  return col ~= 0
    and api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

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
    experimental = {
      ghost_text = true,
    },
    window = {
      completion = {
        border = mo.style.border.current,
        winhighlight = "Normal:Pmenu,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
      },
      documentation = {
        border = mo.style.border.current,
        winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
      },
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
            return vim.api.nvim_list_bufs()
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
          vim_item.abbr = vim_item.abbr:sub(1, MAX) .. icons.misc.ellipsis
        end
        vim_item.kind = fmt("%s %s", icons.lsp.kinds[vim_item.kind:lower()], vim_item.kind)
        vim_item.menu = source_names[entry.source.name] or entry.source.name
        return vim_item
      end,
    },
    mapping = {
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
        elseif luasnip.expand_or_locally_jumpable() then
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
        elseif luasnip.locally_jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s", "c" }),
      ["<CR>"] = cmp.mapping(
        cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
        { "i", "c" }
      ),
      ["<C-e>"] = { i = cmp.mapping.abort(), c = cmp.mapping.close() },
      ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-8), { "i", "c" }),
      ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(8), { "i", "c" }),
      -- ["<C-c>"] = cmp.mapping.complete(),
      ["<Down>"] = cmp.mapping(
        cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        { "i", "c" }
      ),
      ["<Up>"] = cmp.mapping(
        cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        { "i", "c" }
      ),
    },
  })

  cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = "buffer" },
    },
  })

  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = "path" },
    }, {
      { name = "cmdline" },
    }),
  })
end

return M
