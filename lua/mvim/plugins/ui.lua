local M = {
  {
    "akinsho/bufferline.nvim",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      { "[b", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev buffer" },
      { "]b", "<Cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
      { "<leader>bp", "<Cmd>BufferLinePick<CR>", desc = "Buffer pick" },
      { "<leader>bc", "<Cmd>BufferLinePickClose<CR>", desc = "Pick close" },
      { "<leader>b[", "<Cmd>BufferLineMovePrev<CR>", desc = "Move prev" },
      { "<leader>b]", "<Cmd>BufferLineMoveNext<CR>", desc = "Move next" },
      { "<leader>bD", "<Cmd>BufferLineCloseOthers<CR>", desc = "Close others" },
      { "<leader>bH", "<Cmd>BufferLineCloseLeft<CR>", desc = "Close to the left" },
      { "<leader>bL", "<Cmd>BufferLineCloseRight<CR>", desc = "Close to the right" },
    },
    opts = function()
      local ctp = require("catppuccin.groups.integrations.bufferline")
      local colors = require("catppuccin.palettes").get_palette()
      local transparent = require("mvim.config").transparent

      return {
        options = {
          indicator = { icon = "▍", style = "icon" },
          buffer_close_icon = "󰖭",
          modified_icon = "●",
          left_trunc_marker = " ",
          right_trunc_marker = " ",
          right_mouse_command = false,
          diagnostics = "nvim_lsp",
          diagnostics_indicator = function(_, level)
            local icons = require("mvim.config").icons.diagnostics
            level = level:match("warn") and "warn" or level
            return icons[level] or ""
          end,
          offsets = {
            {
              filetype = "neo-tree",
              text = "Explorer",
              separator = transparent,
              text_align = "center",
              highlight = "PanelHeading",
            },
            {
              filetype = "undotree",
              text = "Undotree",
              separator = transparent,
              text_align = "center",
              highlight = "PanelHeading",
            },
            {
              filetype = "dapui_scopes",
              text = "Debugger",
              separator = transparent,
              text_align = "center",
              highlight = "PanelHeading",
            },
          },
          move_wraps_at_ends = true,
          show_close_icon = false,
          separator_style = transparent and "thin" or "slope",
          show_buffer_close_icons = false,
          sort_by = "insert_after_current",
        },
        highlights = ctp.get({
          custom = {
            all = {
              buffer_selected = { fg = colors.lavender },

              error = { fg = colors.surface1 },
              error_diagnostic = { fg = colors.surface1 },

              warning = { fg = colors.surface1 },
              warning_diagnostic = { fg = colors.surface1 },

              info = { fg = colors.surface1 },
              info_diagnostic = { fg = colors.surface1 },

              hint = { fg = colors.surface1 },
              hint_diagnostic = { fg = colors.surface1 },
            },
          },
        }),
      }
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    event = { "BufNewFile", "BufReadPost" },
    opts = function()
      local lualine = require("mvim.util").lualine

      return {
        options = {
          theme = "catppuccin",
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
            lualine.components.python_env,
            lualine.components.dap,
            -- lualine.components.lsp,
            -- lualine.components.treesitter,
            lualine.components.spaces,
            lualine.components.filesize,
            -- lualine.components.lazy,
          },
          lualine_y = { lualine.components.location },
          lualine_z = { lualine.components.scrollbar },
        },
      }
    end,
  },

  {
    "luukvbaal/statuscol.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = function()
      local builtin = require("statuscol.builtin")
      local sign_name = { "Dap*", "todo%-sign%-", "neotest_*" }

      return {
        bt_ignore = { "terminal", "nofile" },
        relculright = true,
        segments = {
          { sign = { name = sign_name, namespace = { "diagnostic" }, maxwidth = 1, auto = true } },
          { text = { builtin.lnumfunc, " " } },
          { sign = { namespace = { "gitsign" }, maxwidth = 1, colwidth = 1, auto = true } },
          { text = { builtin.foldfunc, " " } },
        },
      }
    end,
  },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    -- stylua: ignore
    keys = {
      { "<leader>nl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
      { "<leader>nh", function() require("noice").cmd("history") end, desc = "Noice History" },
      { "<leader>na", function() require("noice").cmd("all") end, desc = "Noice All" },
      { "<leader>nd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
      { "<C-d>",
        function()
          if not require("noice.lsp").scroll(4) then
            return "<C-d>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll down",
        mode = { "i", "n", "s" },
      },
      {
        "<C-u>",
        function()
          if not require("noice.lsp").scroll(-4) then
            return "<C-u>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll up",
        mode = { "i", "n", "s" },
      },
    },
    dependencies = {
      {
        "rcarriga/nvim-notify",
        opts = {
          timeout = 3000,
          stages = "static",
          max_height = function()
            return math.floor(vim.o.lines * 0.7)
          end,
          max_width = function()
            return math.floor(vim.o.columns * 0.7)
          end,
          on_open = function(win)
            vim.api.nvim_win_set_config(win, { zindex = 100 })
          end,
        },
      },
    },
    opts = {
      cmdline = {
        view = "cmdline",
      },
      lsp = {
        documentation = {
          opts = {
            size = {
              max_height = 15,
              max_width = math.floor(vim.o.columns * 0.8),
            },
          },
        },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
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
          filter = {
            any = {
              { event = "notify", max_height = 1 },
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
        lsp_doc_border = require("mvim.config").transparent,
      },
    },
  },
}

return M
