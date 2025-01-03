Mo.C.init()

return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    -- stylua: ignore
    keys = {
      { "<leader>gg", function() Snacks.lazygit({ configure = false, win = { border= Mo.C.border } }) end, desc = "Lazygit" },
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
      { "<leader>bD", function() Snacks.bufdelete.other() end, desc = "Delete Other" },
      { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference" },
      { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference" },
    },
    opts = {
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
      bigfile = { enabled = true },
      quickfile = { enabled = true },
      statuscolumn = { folds = { git_hl = true } },
      words = { enabled = true },
      styles = {
        notification = {
          wo = { wrap = true },
        },
        input = {
          relative = "cursor",
          row = -3,
          col = -5,
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
              action = ":Telescope find_files",
              key = "f",
            },
            {
              text = {
                { "  ", hl = "Special" },
                { "Find Text", hl = "CursorLineNr", width = 55 },
                { "g", hl = "Constant" },
              },
              action = ":Telescope live_grep",
              key = "g",
            },
            {
              text = {
                { "  ", hl = "Macro" },
                { "Recent Files", hl = "CursorLineNr", width = 55 },
                { "r", hl = "Constant" },
              },
              action = ":Telescope oldfiles",
              key = "r",
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
