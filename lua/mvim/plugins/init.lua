Mo.C.init()

return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    -- stylua: ignore
    keys = {
      { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
      { "<leader>bD", function() Snacks.bufdelete.other() end, desc = "Delete Other" },
      { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference" },
      { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference" },
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
      { "<leader>fg", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>fw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
      { "<leader>fc", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>fd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
      { "<leader>fs", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
      { "<leader>fR", function() Snacks.picker.resume() end, desc = "Resume" },
      { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
      { "<leader>fl", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
    },
    opts = {
      picker = {
        sources = {
          files = { hidden = true },
          buffers = { layout = "select" },
          grep_buffers = { layout = "ivy" },
        },
        win = {
          input = {
            keys = {
              ["<Esc>"] = { "close", mode = { "n", "i" } },
              ["<C-e>"] = { "toggle_preview", mode = { "i", "n" } },
              ["<C-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
              ["<C-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
              ["<C-f>"] = { "list_scroll_down", mode = { "i", "n" } },
              ["<C-b>"] = { "list_scroll_up", mode = { "i", "n" } },
              ["<C-p>"] = { "history_back", mode = { "i", "n" } },
              ["<C-n>"] = { "history_forward", mode = { "i", "n" } },
            },
          },
          preview = {
            wo = {
              -- number = false,
              signcolumn = "no",
              -- relativenumber = false,
            },
          },
        },
        layouts = {
          default = {
            layout = {
              box = "horizontal",
              width = 0.9,
              min_width = 120,
              height = 0.9,
              {
                box = "vertical",
                border = "rounded",
                title = "{title} {live} {flags}",
                { win = "input", height = 1, border = "bottom" },
                { win = "list", border = "none" },
              },
              { win = "preview", title = "{preview}", border = "rounded", width = 0.6 },
            },
          },
        },
        icons = {
          kinds = Mo.C.icons.kinds,
          diagnostics = Mo.C.icons.diagnostics,
        },
      },
      indent = {
        indent = {
          char = "┊",
        },
        scope = {
          enabled = false,
        },
        chunk = {
          enabled = true,
        },
        filter = function(buf)
          return vim.g.snacks_indent ~= false
            and vim.b[buf].snacks_indent ~= false
            and vim.bo[buf].buftype == ""
            and vim.bo[buf].filetype ~= "markdown"
        end,
      },
      scope = { enabled = true },
      notifier = {
        icons = {
          error = "",
          warn = "",
          info = "",
          debug = "",
          trace = "",
        },
      },
      lazygit = {
        configure = false,
        win = { border = Mo.C.border },
      },
      input = { enabled = true },
      bigfile = { enabled = true },
      quickfile = { enabled = true },
      statuscolumn = { folds = { open = true, git_hl = true } },
      words = { enabled = true },
      styles = {
        notification = {
          wo = { wrap = true },
        },
        input = {
          row = -3,
          col = -5,
          width = 40,
          relative = "cursor",
          title_pos = "left",
          keys = {
            i_esc = { "<esc>", { "cmp_close", "cancel" }, mode = "i", expr = true },
          },
        },
      },
      dashboard = {
        preset = {
          header = [[
      .-') _     ('-.                      (`-.              _   .-')      
      ( OO ) )  _(  OO)                   _(OO  )_           ( '.( OO )_    
  ,--./ ,--,'  (,------.  .-'),-----. ,--(_/   ,. \  ,-.-')   ,--.   ,--.)  
  |   \ |  |\   |  .---' ( OO'  .-.  '\   \   /(__/  |  |OO)  |   `.'   |   
  |    \|  | )  |  |     /   |  | |  | \   \ /   /   |  |  \  |         |   
  |  .     |/  (|  '--.  \_) |  |\|  |  \   '   /,   |  |(_/  |  |'.'|  |   
  |  |\    |    |  .--'    \ |  | |  |   \     /__) ,|  |_.'  |  |   |  |   
  |  | \   |    |  `---.    `'  '-'  '    \   /    (_|  |     |  |   |  |   
  `--'  `--'    `------'      `-----'      `-'       `--'     `--'   `--'   ]],
          keys = {
            {
              text = {
                { "  ", hl = "Character" },
                { "New File", hl = "CursorLineNr", width = 55 },
                { "n", hl = "Constant" },
              },
              key = "n",
              action = ":ene | startinsert",
            },
            {
              text = {
                { "  ", hl = "Label" },
                { "Find File", hl = "CursorLineNr", width = 55 },
                { "f", hl = "Constant" },
              },
              action = function()
                Snacks.picker.files()
              end,
              key = "f",
            },
            {
              text = {
                { "  ", hl = "Special" },
                { "Find Text", hl = "CursorLineNr", width = 55 },
                { "g", hl = "Constant" },
              },
              action = function()
                Snacks.picker.grep()
              end,
              key = "g",
            },
            {
              text = {
                { "  ", hl = "Macro" },
                { "Recent Files", hl = "CursorLineNr", width = 55 },
                { "r", hl = "Constant" },
              },
              action = function()
                Snacks.picker.recent()
              end,
              key = "r",
            },
            {
              text = {
                { "  ", hl = "Identifier" },
                { "Recent Projects", hl = "CursorLineNr", width = 55 },
                { "p", hl = "Constant" },
              },
              action = function()
                Snacks.picker.projects()
              end,
              key = "p",
            },
            {
              text = {
                { "  ", hl = "Error" },
                { "Quit", hl = "CursorLineNr", width = 55 },
                { "q", hl = "Constant" },
              },
              action = ":qa",
              key = "q",
            },
          },
        },
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>os")
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>ow")
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>oL")
          Snacks.toggle.line_number():map("<leader>ol")
          Snacks.toggle.treesitter():map("<leader>ot")
          Snacks.toggle.diagnostics():map("<leader>od")
          Snacks.toggle.inlay_hints():map("<leader>oh")
          Snacks.toggle.zen():map("<leader><Space>")
        end,
      })
    end,
  },
}
