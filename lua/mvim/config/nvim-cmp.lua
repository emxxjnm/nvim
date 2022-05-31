local M = {}

local fn = vim.fn

local function check_backspace()
  local col = fn.col(".") - 1
  return col == 0 or fn.getline("."):sub(col, col):match("%s")
end

local feedkeys = vim.fn.feedkeys
local replace_termcodes = vim.api.nvim_replace_termcodes
local backspace_keys = replace_termcodes('<tab>', true, true, true)
local snippet_next_keys = replace_termcodes('<plug>luasnip-expand-or-jump', true, true, true)
local snippet_prev_keys = replace_termcodes('<plug>luasnip-jump-prev', true, true, true)

function M.setup()
  local cmp_status_ok, cmp = pcall(require, "cmp")
  if not cmp_status_ok then
    return
  end

  local luasnip_status_ok, luasnip = pcall(require, "luasnip")
  if not luasnip_status_ok then
    return
  end

  local kind_icons = {
    Class = " ",
    Color = " ",
    Constant = "ﲀ ",
    Constructor = " ",
    Enum = "練",
    EnumMember = " ",
    Event = " ",
    Field = " ",
    File = "",
    Folder = " ",
    Function = " ",
    Interface = "ﰮ ",
    Keyword = " ",
    Method = " ",
    Module = " ",
    Operator = "",
    Property = " ",
    Reference = " ",
    Snippet = " ",
    Struct = " ",
    Text = " ",
    TypeParameter = " ",
    Unit = "塞",
    Value = " ",
    Variable = " ",
  }

  local source_names = {
    luasnip = "[ Snippet]",
    nvim_lsp = "[ LSP]",
    buffer = "[ Buffer]",
    path = "[ Path]",
    nvim_lua = "[ NeoVim]",
  }
  local duplicates = {
    buffer = 1,
    path = 1,
    nvim_lsp = 0,
    luasnip = 1,
  }

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
      { name = "luasnip" },
      { name = "nvim_lsp" },
      { name = "buffer" },
      { name = "path" },

      { name = "nvim_lua" }, -- cmp-nvim-lua
      -- { name = "cmp_tabnine" }, -- cmp-tabnine
      -- { name = "calc" }, -- cmp-calc
      -- { name = "emoji" }, -- cmp-emoji
      -- { name = "treesitter" }, -- cmp-treesitter
      -- { name = "crates" }, -- crates.nvim: rust
      -- { name = "tmux" }, -- cmp-tmux
      -- { name = "copilot" }, -- cmp-copilot
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
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
      ['<Tab>'] = function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          feedkeys(snippet_next_keys, '')
        elseif check_backspace() then
          feedkeys(backspace_keys, 'n')
        else
          fallback()
        end
      end,
      ['<s-tab>'] = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          feedkeys(snippet_prev_keys, '')
        else
          fallback()
        end
      end,
    }),
  })
end

return M
