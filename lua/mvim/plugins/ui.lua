local Util = require("mvim.util")

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
      return {
        options = {
          theme = "catppuccin",
          component_separators = "",
          section_separators = "",
          disabled_filetypes = {
            statusline = {
              "qf",
              "lazy",
              "help",
              "diff",
              "alpha",
              "mason",
              "undotree",
              "toggleterm",
              "neo-tree",
              "dap-repl",
              "dapui_stacks",
              "dapui_scopes",
              "dapui_watches",
              "dapui_breakpoints",
              "TelescopePrompt",
            },
          },
        },
        sections = {
          lualine_a = { Util.lualine.components.mode },
          lualine_b = { Util.lualine.components.branch },
          lualine_c = {
            Util.lualine.components.diff,
            Util.lualine.components.diagnostics,
          },
          lualine_x = {
            Util.lualine.components.lsp_progress,
            Util.lualine.components.python_env,
            Util.lualine.components.dap,
            Util.lualine.components.lsp,
            Util.lualine.components.treesitter,
            Util.lualine.components.spaces,
            Util.lualine.components.filesize,
            -- Util.lualine.components.lazy,
          },
          lualine_y = { Util.lualine.components.location },
          lualine_z = { Util.lualine.components.clock },
        },
        inactive_sections = {
          lualine_a = {
            Util.lualine.components.filetype,
            Util.lualine.components.filename,
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
    -- enabled = false,
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
}

return M
