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
      { "<leader>bL", "<Cmd>BufferLineCloseLeft<CR>", desc = "Close to the left" },
      { "<leader>bR", "<Cmd>BufferLineCloseRight<CR>", desc = "Close to the right" },
    },
    opts = function()
      local colors = require("catppuccin.palettes").get_palette()
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
              separator = true,
              text_align = "center",
              highlight = "PanelHeading",
            },
            {
              filetype = "undotree",
              text = "Undotree",
              separator = true,
              text_align = "center",
              highlight = "PanelHeading",
            },
            {
              filetype = "dapui_scopes",
              text = "Debugger",
              separator = true,
              text_align = "center",
              highlight = "PanelHeading",
            },
          },
          show_close_icon = false,
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

  -- lualine
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      local fn, api = vim.fn, vim.api
      local colors = require("catppuccin.palettes").get_palette()

      local conditions = {
        buffer_not_empty = function()
          return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
        end,
        hide_in_width = function()
          return vim.o.columns > 80
        end,
      }

      local components = {
        mode = {
          "mode",
          fmt = function(str)
            return string.sub(str, 1, 1)
          end,
          separator = {
            right = I.navigation.right_half_circle_thick,
            left = I.navigation.left_half_circle_thick,
          },
        },

        branch = {
          "branch",
          icon = { I.git.branch, color = { fg = colors.pink, gui = "bold" } },
          color = { gui = "bold" },
          separator = {
            right = I.navigation.right_half_circle_thick,
          },
        },

        filetype = {
          "filetype",
          icon_only = true,
          padding = { right = 0, left = 1 },
        },

        filename = {
          "filename",
          file_status = false,
          color = { fg = colors.lavender },
        },

        filesize = {
          "filesize",
          icon = I.misc.creation,
          color = { fg = colors.lavender },
          padding = { left = 0, right = 1 },
          condition = conditions.buffer_not_empty,
        },

        diagnostics = {
          "diagnostics",
          sources = { "nvim_diagnostic" },
          sections = { "error", "warn", "info", "hint" },
          symbols = {
            error = I.diagnostics.error .. " ",
            warn = I.diagnostics.warn .. " ",
            info = I.diagnostics.info .. " ",
            hint = I.diagnostics.hint .. " ",
          },
        },

        treesitter = {
          function()
            return I.misc.treesitter
          end,
          color = function()
            local buf = api.nvim_get_current_buf()
            local ts = vim.treesitter.highlighter.active[buf]
            return { fg = ts and not vim.tbl_isempty(ts) and colors.green or colors.red }
          end,
        },

        python_env = {
          function()
            if vim.bo.filetype == "python" then
              local venv = vim.env.VIRTUAL_ENV
              if venv then
                local venv_name = fn.fnamemodify(venv, ":t")
                local ok, devicons = pcall(require, "nvim-web-devicons")
                if ok then
                  local icon, _ = devicons.get_icon(".py")
                  return string.format(icon .. " (%s)", venv_name)
                end
                return string.format("(%s)", venv_name)
              end
            end
            return ""
          end,
          color = { fg = colors.lavender },
          cond = conditions.hide_in_width,
        },

        lsp = {
          function()
            local buf_clients = vim.lsp.get_active_clients({ bufnr = 0 })
            if vim.tbl_isempty(buf_clients) then
              return "LS Inactive"
            end

            local buf_ft = vim.bo.filetype
            local buf_client_names = {}

            -- add client
            for _, client in pairs(buf_clients) do
              if client.name ~= "null-ls" then
                table.insert(buf_client_names, client.name)
              end
            end

            local U = require("mvim.utils")
            local formatters = U.list_registered_formatters(buf_ft)
            vim.list_extend(buf_client_names, formatters, 1, #formatters)

            local linters = U.list_registered_linters(buf_ft)
            vim.list_extend(buf_client_names, linters, 1, #linters)

            local clients = fn.uniq(buf_client_names)
            return "LSP(s):[" .. table.concat(clients, " · ") .. "]"
          end,
          icon = I.lsp.lsp,
          color = { fg = colors.mauve },
          cond = conditions.hide_in_width,
        },

        diff = {
          "diff",
          source = function()
            ---@diagnostic disable-next-line: undefined-field
            local gitsigns = vim.b.gitsigns_status_dict
            if gitsigns then
              return {
                added = gitsigns.added,
                modified = gitsigns.changed,
                removed = gitsigns.removed,
              }
            end
          end,
          symbols = {
            added = I.git.added .. " ",
            modified = I.git.modified .. " ",
            removed = I.git.deleted .. " ",
          },
          cond = conditions.hide_in_width,
        },

        location = {
          function()
            local line = fn.line(".")
            local lines = fn.line("$")
            local col = fn.virtcol(".")
            return string.format("%3d/%d:%-2d", line, lines, col)
          end,
          icon = { I.misc.milestone, color = { fg = colors.pink, gui = "bold" } },
          separator = { left = I.navigation.left_half_circle_thick },
          color = { gui = "bold" },
        },

        progress = {
          function()
            local current_line = fn.line(".")
            local total_lines = fn.line("$")
            local chars = I.misc.progress
            local line_ratio = current_line / total_lines
            local index = math.ceil(line_ratio * #chars)
            return chars[index]
          end,
          color = { fg = colors.surface0 },
        },

        spaces = {
          function()
            if not api.nvim_buf_get_option(0, "expandtab") then
              return "Tab:" .. api.nvim_buf_get_option(0, "tabstop")
            end
            local size = api.nvim_buf_get_option(0, "shiftwidth")
            if size == 0 then
              size = api.nvim_buf_get_option(0, "tabstop")
            end
            return "Spaces:" .. size
          end,
          padding = { left = 1, right = 2 },
          cond = conditions.hide_in_width,
          color = { fg = colors.sapphire },
        },

        clock = {
          function()
            return os.date("%R")
          end,
          icon = I.misc.clock,
          separator = {
            right = I.navigation.right_half_circle_thick,
            left = I.navigation.left_half_circle_thick,
          },
        },
      }
      require("lualine").setup({
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
          lualine_a = { components.mode },
          lualine_b = { components.branch },
          lualine_c = { components.diff, components.diagnostics },
          lualine_x = {
            components.python_env,
            components.lsp,
            components.treesitter,
            components.spaces,
            components.filesize,
          },
          lualine_y = { components.location },
          lualine_z = { components.clock },
        },
        inactive_sections = {
          lualine_a = { components.filetype, components.filename },
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {},
        },
      })
    end,
  },
}

return M
