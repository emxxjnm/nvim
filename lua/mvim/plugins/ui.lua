local icons = mo.styles.icons

local M = {
  -- dashboard
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    opts = function()
      local dashboard = require("alpha.themes.dashboard")

      local function button(hl, ...)
        local btn = dashboard.button(...)
        local details = select(2, ...)
        local icon = details:match("[^%w%s]+")
        btn.opts.hl = { { hl, 0, #icon + 1 } }
        btn.opts.hl_shortcut = "MatchParen"
        return btn
      end

      dashboard.section.header.val = mo.styles.banner
      dashboard.section.buttons.val = {
        button(
          "Statement",
          "n",
          icons.documents.new_file .. "  New File",
          ":ene<Bar>startinsert<CR>"
        ),
        button("Special", "f", icons.misc.search .. "  Find File", ":Telescope find_files<CR>"),
        button("Operator", "r", icons.misc.history .. "  Recent Files", ":Telescope oldfiles<CR>"),
        button(
          "Structure",
          "p",
          icons.documents.repo .. "  Recent Projects",
          ":Telescope projects<CR>"
        ),
        button("String", "c", icons.misc.vim .. "  Config", ":e $MYVIMRC<CR>"),
        button("Error", "q", icons.misc.exit .. "  Quit", ":qa<CR>"),
      }

      dashboard.section.header.opts.hl = "Function"
      dashboard.section.footer.opts.hl = "Conceal"

      dashboard.config.layout = {
        { type = "padding", val = 5 },
        dashboard.section.header,
        { type = "padding", val = 1 },
        dashboard.section.buttons,
        { type = "padding", val = 1 },
        dashboard.section.footer,
      }

      return dashboard
    end,
    config = function(_, dashboard)
      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "AlphaReady",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      require("alpha").setup(dashboard.config)

      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        callback = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          local version = vim.version()
          local nvim_version_info = version
              and string.format(
                icons.misc.vim .. " Neovim v%d.%d.%d",
                version.major,
                version.minor,
                version.patch
              )
            or " Unknow Neovim version"

          dashboard.section.footer.val = string.format(
            "--- %s, %s %d plugins in %d ms ---",
            nvim_version_info,
            icons.misc.electron,
            stats.count,
            ms
          )
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },

  -- buffer line
  {
    "akinsho/bufferline.nvim",
    event = "BufAdd",
    keys = {
      { "[b", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev buffer" },
      { "]b", "<Cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
    },
    opts = function()
      local colors = require("catppuccin.palettes").get_palette()
      local ctp = require("catppuccin.groups.integrations.bufferline")

      return {
        options = {
          indicator = { icon = icons.misc.indicator, style = "icon" },
          buffer_close_icon = icons.misc.cross,
          modified_icon = icons.misc.dot,
          close_icon = icons.misc.bold_close,
          left_trunc_marker = icons.misc.triangle_left,
          right_trunc_marker = icons.misc.triangle_right,
          diagnostics = "nvim_lsp",
          diagnostics_indicator = function(_, _, diagnostics, _)
            local symbols = {
              error = icons.diagnostics.error .. " ",
              warning = icons.diagnostics.warn .. " ",
              info = icons.diagnostics.info .. " ",
              hint = icons.diagnostics.hint .. " ",
            }
            local result = {}
            for name, count in pairs(diagnostics) do
              if symbols[name] and count > 0 then
                table.insert(result, symbols[name] .. count)
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
            return " " .. string.sub(str, 1, 1) .. " "
          end,
        },

        branch = {
          "branch",
          icon = { icons.git.branch, color = { fg = colors.pink, gui = "bold" } },
          color = { gui = "bold" },
          separator = {
            right = icons.misc.right_half_circle_thick,
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
          icon = icons.misc.creation,
          color = { fg = colors.lavender },
          padding = { left = 0, right = 1 },
          condition = conditions.buffer_not_empty,
        },

        diagnostics = {
          "diagnostics",
          sources = { "nvim_diagnostic" },
          sections = { "error", "warn", "info", "hint" },
          symbols = {
            error = icons.diagnostics.error .. " ",
            warn = icons.diagnostics.warn .. " ",
            info = icons.diagnostics.info .. " ",
            hint = icons.diagnostics.hint .. " ",
          },
        },

        treesitter = {
          function()
            return icons.misc.treesitter
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
            return icons.misc.lsp .. " LSP(s): [" .. table.concat(clients, " · ") .. "]"
          end,
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
            added = icons.git.added .. " ",
            modified = icons.git.modified .. " ",
            removed = icons.git.deleted .. " ",
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
          icon = { icons.misc.milestone, color = { fg = colors.pink, gui = "bold" } },
          separator = { left = icons.misc.left_half_circle_thick },
          color = { gui = "bold" },
        },

        progress = {
          function()
            local current_line = fn.line(".")
            local total_lines = fn.line("$")
            local chars = icons.misc.progress
            local line_ratio = current_line / total_lines
            local index = math.ceil(line_ratio * #chars)
            return chars[index]
          end,
          color = { fg = colors.surface0 },
        },

        spaces = {
          function()
            if not api.nvim_buf_get_option(0, "expandtab") then
              return "Tab: " .. api.nvim_buf_get_option(0, "tabstop")
            end
            local size = api.nvim_buf_get_option(0, "shiftwidth")
            if size == 0 then
              size = api.nvim_buf_get_option(0, "tabstop")
            end
            return "Spaces: " .. size
          end,
          padding = { left = 1, right = 2 },
          cond = conditions.hide_in_width,
          color = { fg = colors.sapphire },
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
              "alpha",
              "mason",
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
          lualine_z = { components.progress },
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
