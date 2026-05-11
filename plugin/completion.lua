-- blink.cmp: InsertEnter/CmdlineEnter trigger
vim.api.nvim_create_autocmd({ "InsertEnter", "CmdlineEnter" }, {
  group = vim.api.nvim_create_augroup("mvim_completion", { clear = true }),
  once = true,
  callback = function()
    vim.pack.add({
      "https://github.com/saghen/blink.lib",
      "https://github.com/saghen/blink.cmp",
    })

    require("blink.cmp").setup({
      keymap = {
        preset = "none",
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
        ["<C-e>"] = { "hide", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
      },
      completion = {
        keyword = { range = "full" },
        trigger = { show_on_backspace = true },
        list = {
          selection = {
            preselect = false,
            auto_insert = false,
          },
        },
        menu = {
          draw = {
            columns = {
              { "kind_icon", "kind" },
              { "label", "label_description", gap = 1 },
              { "source_name" },
            },
          },
          border = Mo.C.border,
          winhighlight = "Normal:Pmenu,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
        },
        documentation = {
          auto_show = true,
          window = {
            border = Mo.C.border,
            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,EndOfBuffer:EndOfBuffer",
          },
        },
        ghost_text = {
          enabled = true,
          show_without_selection = true,
        },
      },
      signature = {
        enabled = true,
        trigger = {
          show_on_accept = true,
        },
        window = {
          border = Mo.C.border,
          max_width = 120,
          winhighlight = "Normal:Pmenu,FloatBorder:FloatBorder",
          show_documentation = true,
        },
      },
      cmdline = {
        completion = {
          menu = { auto_show = true },
          list = {
            selection = {
              preselect = false,
              auto_insert = false,
            },
          },
        },
        keymap = { preset = "inherit" },
      },
      appearance = {
        kind_icons = Mo.C.icons.kinds,
      },
    })
  end,
})
