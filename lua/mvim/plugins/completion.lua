local M = {
  "hrsh7th/nvim-cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-nvim-lsp",
    "saadparwaiz1/cmp_luasnip",
    {
      "L3MON4D3/LuaSnip",
      build = "make install_jsregexp",
      keys = {
        {
          "<C-o>",
          function()
            if require("luasnip").choice_active() then
              require("luasnip").change_choice(1)
            end
          end,
          mode = { "s", "i" },
          desc = "Select option",
        },
      },
      config = function()
        require("luasnip").setup({
          delete_check_events = "TextChanged",
          ext_opts = {
            [require("luasnip.util.types").choiceNode] = {
              active = {
                virt_text = {
                  { "󰠖 ", "Type" },
                },
              },
            },
          },
        })
        require("luasnip.loaders.from_vscode").lazy_load({
          paths = vim.fn.stdpath("config") .. "/snippets",
        })
      end,
    },
  },
  config = function()
    local cmp, luasnip = require("cmp"), require("luasnip")
    local select = cmp.SelectBehavior.Select
    local border = require("mvim.config").get_border()

    cmp.setup({
      preselect = cmp.PreselectMode.None,
      experimental = { ghost_text = true },
      window = {
        completion = {
          border = border,
          winhighlight = "Normal:Pmenu,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
        },
        documentation = {
          border = border,
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
      }, {
        { name = "path" },
        {
          name = "buffer",
          option = {
            get_bufnrs = function()
              return vim.api.nvim_list_bufs()
            end,
          },
          keyword_length = 2,
        },
      }),
      formatting = {
        expandable_indicator = false,
        fields = { "kind", "abbr", "menu" },
        format = function(entry, item)
          local icons = require("mvim.config").icons.kinds
          item.kind = string.format("%s%s", icons[item.kind], item.kind)
          item.menu = ({
            luasnip = "[Snip]",
            nvim_lsp = "[LSP]",
            buffer = "[Buf]",
            path = "[Path]",
            cmdline = "[Cmd]",
          })[entry.source.name] or entry.source.name
          return item
        end,
      },
      mapping = {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item({ behavior = select })
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
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
        ["<CR>"] = cmp.mapping(cmp.mapping.confirm({ select = false }), { "i", "c" }),
        ["<C-e>"] = { i = cmp.mapping.abort(), c = cmp.mapping.close() },
        ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-8), { "i", "c" }),
        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(8), { "i", "c" }),
        -- ["<C-c>"] = cmp.mapping.complete(),
        ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = select }), { "i", "c" }),
        ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = select }), { "i", "c" }),
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
        { name = "cmdline" },
      }),
    })
  end,
}

return M
