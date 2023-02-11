local M = {
  "hrsh7th/nvim-cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  opts = function()
    local source_names = {
      luasnip = "[Snip]",
      nvim_lsp = "[LSP]",
      buffer = "[Buf]",
      path = "[Path]",
      cmdline = "[Cmd]",
    }

    local cmp, luasnip = require("cmp"), require("luasnip")

    local function has_words_before()
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0
        and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s")
          == nil
    end

    return {
      defaults = {
        experimental = { ghost_text = true },
        window = {
          completion = {
            border = mo.styles.border,
            winhighlight = "Normal:Pmenu,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
          },
          documentation = {
            border = mo.styles.border,
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
          {
            name = "buffer",
            option = {
              get_bufnrs = function()
                return vim.api.nvim_list_bufs()
              end,
            },
          },
        }),
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, item)
            item.kind =
              string.format("%s %s", mo.styles.icons.lsp.kinds[item.kind:lower()], item.kind)
            item.menu = source_names[entry.source.name] or entry.source.name
            return item
          end,
        },
        mapping = {
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
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
          ["<CR>"] = cmp.mapping(cmp.mapping.confirm({ select = false }), { "i", "c" }),
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
      },
      search = {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      },
      command = {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      },
    }
  end,
  config = function(_, opts)
    local cmp = require("cmp")
    cmp.setup(opts.defaults)

    cmp.setup.cmdline({ "/", "?" }, opts.search)
    cmp.setup.cmdline(":", opts.command)
  end,
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
          desc = "Select within a list of options",
        },
      },
      opts = function()
        local types = require("luasnip.util.types")

        return {
          region_check_events = "CursorMoved,CursorHold,InsertEnter",
          delete_check_events = "InsertLeave",
          enable_autosnippets = true,
          ext_opts = {
            [types.choiceNode] = {
              active = {
                virt_text = {
                  { mo.styles.icons.misc.snow .. " ", "Type" },
                },
              },
            },
          },
        }
      end,
      config = function(_, opts)
        require("luasnip").setup(opts)
        require("luasnip.loaders.from_vscode").lazy_load({
          paths = vim.fn.stdpath("config") .. "/snippets",
        })
      end,
    },
  },
}

return M
