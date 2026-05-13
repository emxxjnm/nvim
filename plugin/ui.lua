vim.schedule(function()
  local lualine = require("mvim.lualine")

  vim.pack.add({
    "https://github.com/MunifTanjim/nui.nvim",
    "https://github.com/nvim-tree/nvim-web-devicons",
    "https://github.com/akinsho/bufferline.nvim",
    "https://github.com/nvim-lualine/lualine.nvim",
    "https://github.com/folke/noice.nvim",
  })

  -- bufferline
  require("bufferline").setup({
    options = {
      indicator = { icon = "▍", style = "icon" },
      buffer_close_icon = "󰖭",
      modified_icon = "●",
      left_trunc_marker = " ",
      right_trunc_marker = " ",
      right_mouse_command = "",
      diagnostics = "nvim_lsp",
      diagnostics_indicator = function(_, level)
        level = level:match("warn") and "warn" or level
        return Mo.C.icons.diagnostics[level] or ""
      end,
      offsets = {
        {
          filetype = "neo-tree",
          text = "Explorer",
          separator = Mo.C.transparent,
          text_align = "center",
          highlight = "PanelHeading",
        },
        {
          filetype = "Avante",
          separator = Mo.C.transparent,
          text_align = "center",
          highlight = "PanelHeading",
        },
        {
          filetype = "dapui_scopes",
          text = "Debugger",
          separator = Mo.C.transparent,
          text_align = "center",
          highlight = "PanelHeading",
        },
      },
      move_wraps_at_ends = true,
      show_close_icon = false,
      separator_style = Mo.C.transparent and "thin" or "slope",
      show_buffer_close_icons = false,
      sort_by = "insert_after_current",
    },
    highlights = Mo.C.theme.bufferline_highlights({
      buffer_selected = { fg = Mo.C.palette.lavender },
      error = { fg = Mo.C.palette.muted },
      error_diagnostic = { fg = Mo.C.palette.muted },
      warning = { fg = Mo.C.palette.muted },
      warning_diagnostic = { fg = Mo.C.palette.muted },
      info = { fg = Mo.C.palette.muted },
      info_diagnostic = { fg = Mo.C.palette.muted },
      hint = { fg = Mo.C.palette.muted },
      hint_diagnostic = { fg = Mo.C.palette.muted },
    }),
  })

  -- lualine
  require("lualine").setup({
    options = {
      theme = Mo.C.theme.lualine,
      component_separators = "",
      section_separators = "",
      disabled_filetypes = {
        statusline = { "dashboard" },
      },
      globalstatus = true,
    },
    sections = {
      lualine_a = { lualine.components.mode },
      lualine_b = { lualine.components.branch },
      lualine_c = {
        lualine.components.diff,
        lualine.components.diagnostics,
      },
      lualine_x = {
        lualine.components.dap,
        lualine.components.spaces,
        lualine.components.filesize,
      },
      lualine_y = { lualine.components.location },
      lualine_z = { lualine.components.scrollbar },
    },
  })

  -- noice
  require("noice").setup({
    cmdline = { view = "cmdline" },
    lsp = {
      signature = { enabled = false },
      documentation = {
        opts = {
          size = {
            max_height = 15,
            max_width = 120,
          },
        },
      },
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      },
    },
    routes = {
      {
        filter = {
          event = "msg_show",
          any = {
            { find = "%d+L, %d+B" },
            { find = "; after #%d+" },
            { find = "; before #%d+" },
            { find = "%d+ fewer lines" },
            { find = "^Hunk %d+ of %d" },
            { find = "^No hunks" },
            { find = "^E486" },
            { find = "%d+ more lines" },
            { find = "%d+ lines yanked" },
          },
        },
        view = "mini",
      },
      {
        opts = { skip = true },
        filter = {
          event = "msg_show",
          any = {
            { find = "search hit %w+, continuing at %w+" },
          },
        },
      },
    },
    presets = {
      bottom_search = true,
      long_message_to_split = true,
      lsp_doc_border = Mo.C.transparent,
    },
  })

  -- stylua: ignore start
  local keymap = vim.keymap.set
  keymap("n", "[b", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" })
  keymap("n", "]b", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
  keymap("n", "<leader>bp", "<Cmd>BufferLinePick<CR>", { desc = "Buffer pick" })
  keymap("n", "<leader>bc", "<Cmd>BufferLinePickClose<CR>", { desc = "Pick close" })
  keymap("n", "<leader>b[", "<Cmd>BufferLineMovePrev<CR>", { desc = "Move prev" })
  keymap("n", "<leader>b]", "<Cmd>BufferLineMoveNext<CR>", { desc = "Move next" })
  keymap("n", "<leader>bH", "<Cmd>BufferLineCloseLeft<CR>", { desc = "Close to the left" })
  keymap("n", "<leader>bL", "<Cmd>BufferLineCloseRight<CR>", { desc = "Close to the right" })
  keymap("n", "<leader>nl", function() require("noice").cmd("last") end, { desc = "Noice Last Message" })
  keymap("n", "<leader>nh", function() require("noice").cmd("history") end, { desc = "Noice History" })
  keymap("n", "<leader>na", function() require("noice").cmd("all") end, { desc = "Noice All" })
  keymap("n", "<leader>nd", function() require("noice").cmd("dismiss") end, { desc = "Dismiss All" })
  keymap({ "i", "n", "s" }, "<C-d>", function()
    if not require("noice.lsp").scroll(4) then return "<C-d>" end
  end, { silent = true, expr = true, desc = "Scroll down" })
  keymap({ "i", "n", "s" }, "<C-u>", function()
    if not require("noice.lsp").scroll(-4) then return "<C-u>" end
  end, { silent = true, expr = true, desc = "Scroll up" })
  -- stylua: ignore end
end)
