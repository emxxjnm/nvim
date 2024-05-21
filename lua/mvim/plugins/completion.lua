local M = {
  "hrsh7th/nvim-cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    local cmp = require("cmp")
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
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "path" },
      }, {
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
        format = function(_, item)
          local icons = require("mvim.config").icons.kinds
          item.kind = string.format("%s%s", icons[item.kind], item.kind)
          return item
        end,
      },
      mapping = {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item({ behavior = select })
          elseif vim.snippet.active({ direction = 1 }) then
            vim.schedule(function()
              vim.snippet.jump(1)
            end)
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item({ behavior = select })
          elseif vim.snippet.active({ direction = -1 }) then
            vim.schedule(function()
              vim.snippet.jump(-1)
            end)
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<CR>"] = cmp.mapping(cmp.mapping.confirm({ select = false }), { "i", "c" }),
        ["<C-e>"] = { i = cmp.mapping.abort(), c = cmp.mapping.close() },
        ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
        ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
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
      sources = {
        { name = "cmdline" },
      },
    })
  end,
}

return M
