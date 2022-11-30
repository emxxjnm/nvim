local M = {}

local icons = mo.style.icons
local colors = mo.style.palettes

local fn, bo, api = vim.fn, vim.bo, vim.api
local list_extend, tbl_isempty = vim.list_extend, vim.tbl_isempty

local function diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed,
    }
  end
end

local conditions = {
  buffer_not_empty = function()
    return fn.empty(fn.expand("%:t")) ~= 1
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
      left = icons.misc.left_half_circle_thick,
      right = icons.misc.right_half_circle_thick,
    },
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
    color = { fg = colors.teal },
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
      return { fg = ts and not tbl_isempty(ts) and colors.green or colors.red }
    end,
  },

  python_env = {
    function()
      if bo.filetype == "python" then
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
      if tbl_isempty(buf_clients) then
        return "LS Inactive"
      end

      local buf_ft = bo.filetype
      local buf_client_names = {}

      -- add client
      for _, client in pairs(buf_clients) do
        if client.name ~= "null-ls" then
          table.insert(buf_client_names, client.name)
        end
      end

      local utils = require("mvim.lsp.utils")
      local formatters = utils.list_registered_formatters(buf_ft)
      list_extend(buf_client_names, formatters)

      local linters = utils.list_registered_linters(buf_ft)
      list_extend(buf_client_names, linters)

      local clients = fn.uniq(buf_client_names)
      return icons.misc.lsp .. " LSP(s): [" .. table.concat(clients, " · ") .. "]"
    end,
    color = { fg = colors.mauve },
    cond = conditions.hide_in_width,
  },

  diff = {
    "diff",
    source = diff_source,
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

function M.setup()
  require("lualine").setup({
    options = {
      icons_enabled = true,
      theme = "catppuccin",
      component_separators = "",
      section_separators = "",
      disabled_filetypes = {
        statusline = {
          "qf",
          "alpha",
          "packer",
          "NvimTree",
          "toggleterm",
          "neo-tree",
          "dap-repl",
          "dapui_stacks",
          "dapui_scopes",
          "dapui_watches",
          "dapui_breakpoints",
          "TelescopePrompt",
        },
        winbar = {},
      },
      ignore_focus = {},
      always_divide_middle = true,
      globalstatus = false,
      refresh = {
        statusline = 800,
        tabline = 1000,
        winbar = 1000,
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
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {},
  })
end

return M
