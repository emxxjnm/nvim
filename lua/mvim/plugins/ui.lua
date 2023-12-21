local M = {
  {
    "akinsho/bufferline.nvim",
    event = "BufReadPre",
    keys = {
      { "[b", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev buffer" },
      { "]b", "<Cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
      { "<leader>bp", "<Cmd>BufferLinePick<CR>", desc = "Buffer pick" },
      { "<leader>bc", "<Cmd>BufferLinePickClose<CR>", desc = "Pick close" },
      { "<leader>b[", "<Cmd>BufferLineMovePrev<CR>", desc = "Move prev" },
      { "<leader>b]", "<Cmd>BufferLineMoveNext<CR>", desc = "Move next" },
      { "<leader>bD", "<Cmd>BufferLineCloseOthers<CR>", desc = "Close others" },
      { "<leader>bL", "<Cmd>BufferLineCloseLeft<CR>", desc = "Close to the left" },
      { "<leader>bR", "<Cmd>BufferLineCloseRight<CR>", desc = "Close to the right" },
    },
    opts = function()
      local ctp = require("catppuccin.groups.integrations.bufferline")

      return {
        options = {
          indicator = { icon = I.navigation.indicator, style = "icon" },
          buffer_close_icon = I.documents.close,
          modified_icon = I.documents.modified,
          close_icon = I.documents.close,
          left_trunc_marker = I.navigation.triangle_left,
          right_trunc_marker = I.navigation.triangle_right,
          diagnostics = "nvim_lsp",
          diagnostics_indicator = function(_, _, diagnostics)
            local result = {}
            for name, count in pairs(diagnostics) do
              name = name:match("warn") and "warn" or name
              if I.diagnostics[name] and count > 0 then
                table.insert(result, I.diagnostics[name] .. " " .. count)
              end
            end
            return #result > 0 and table.concat(result, " ") or ""
          end,
          offsets = {
            {
              filetype = "neo-tree",
              text = "Explorer",
              separator = mo.styles.transparent,
              text_align = "center",
              highlight = "PanelHeading",
            },
            {
              filetype = "undotree",
              text = "Undotree",
              separator = mo.styles.transparent,
              text_align = "center",
              highlight = "PanelHeading",
            },
            {
              filetype = "dapui_scopes",
              text = "Debugger",
              separator = mo.styles.transparent,
              text_align = "center",
              highlight = "PanelHeading",
            },
          },
          move_wraps_at_ends = true,
          show_close_icon = false,
          separator_style = mo.styles.transparent and "thin" or "slope",
          show_buffer_close_icons = false,
          sort_by = "insert_after_current",
        },
        highlights = ctp.get({
          custom = {
            all = {
              buffer_selected = { fg = mo.styles.palettes.lavender },

              error = { fg = mo.styles.palettes.surface1 },
              error_diagnostic = { fg = mo.styles.palettes.surface1 },

              warning = { fg = mo.styles.palettes.surface1 },
              warning_diagnostic = { fg = mo.styles.palettes.surface1 },

              info = { fg = mo.styles.palettes.surface1 },
              info_diagnostic = { fg = mo.styles.palettes.surface1 },

              hint = { fg = mo.styles.palettes.surface1 },
              hint_diagnostic = { fg = mo.styles.palettes.surface1 },
            },
          },
        }),
      }
    end,
  },

  -- lualine
  {
    "nvim-lualine/lualine.nvim",
    -- event = "VeryLazy",
    event = "BufReadPost",
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
            -- lualine.components.lsp_progress,
            lualine.components.python_env,
            lualine.components.dap,
            lualine.components.lsp,
            lualine.components.treesitter,
            lualine.components.spaces,
            lualine.components.filesize,
            -- lualine.components.lazy,
          },
          lualine_y = { lualine.components.location },
          lualine_z = { lualine.components.clock },
        },
        inactive_sections = {
          lualine_a = {
            lualine.components.filetype,
            lualine.components.filename,
          },
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {},
        },
      }
    end,
  },

  {
    "luukvbaal/statuscol.nvim",
    event = "BufReadPre",
    opts = function()
      local builtin = require("statuscol.builtin")
      local sign_name = { "Diagnostic*", "Dap*", "todo%-sign%-", "neotest_*" }

      return {
        bt_ignore = { "terminal", "nofile" },
        relculright = true,
        segments = {
          { sign = { name = sign_name, maxwidth = 1, auto = true } },
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
    dependencies = {
      {
        {
          "rcarriga/nvim-notify",
          opts = {
            timeout = 3000,
            stages = "slide",
            background_colour = mo.styles.transparent and "#000000" or "NotifyBackground",
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
    },
    opts = {
      cmdline = {
        view = "cmdline",
      },
      popupmenu = {
        backend = "cmp",
      },
      lsp = {
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
        lsp_doc_border = mo.styles.transparent,
      },
    },
    keys = {
      {
        "<leader>nl",
        function()
          require("noice").cmd("last")
        end,
        desc = "Noice Last Message",
      },
      {
        "<leader>nh",
        function()
          require("noice").cmd("history")
        end,
        desc = "Noice History",
      },
      {
        "<leader>na",
        function()
          require("noice").cmd("all")
        end,
        desc = "Noice All",
      },
      {
        "<leader>nd",
        function()
          require("noice").cmd("dismiss")
        end,
        desc = "Dismiss All",
      },
      {
        "<c-f>",
        function()
          if not require("noice.lsp").scroll(4) then
            return "<c-f>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll forward",
        mode = { "i", "n", "s" },
      },
      {
        "<c-b>",
        function()
          if not require("noice.lsp").scroll(-4) then
            return "<c-b>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll backward",
        mode = { "i", "n", "s" },
      },
    },
  },
}

return M
