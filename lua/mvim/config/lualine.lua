local M = {}

local icons = mo.style.icons
local colors = mo.style.palettes

local fn = vim.fn
local bo = vim.bo
local api = vim.api
local list_extend = vim.list_extend
local tbl_isempty = vim.tbl_isempty

local conditions = {
  buffer_not_empty = function()
    return fn.empty(fn.expand("%:t")) ~= 1
  end,
  hide_in_width = function()
    return vim.o.columns > 80
  end,
}

local mode = {
  "mode",
  fmt = function(str)
    return string.sub(str, 1, 1)
  end,
  separator = {
    left = icons.misc.left_half_circle_thick,
    right = icons.misc.right_half_circle_thick,
  },
}

local branch = {
  "branch",
  icon = icons.git.branch,
  color = { gui = "bold" },
  separator = {
    right = icons.misc.right_half_circle_thick,
  },
}

local filetype = {
  "filetype",
  icon_only = true,
  padding = { right = 0, left = 1 },
}

local filename = {
  "filename",
  file_status = false,
  color = { fg = colors.lavender },
}

local filesize = {
  "filesize",
  icon = icons.misc.creation,
  color = { fg = colors.teal },
  padding = { left = 0, right = 1 },
  condition = conditions.buffer_not_empty,
}

local diagnostics = {
  "diagnostics",
  sources = { "nvim_diagnostic" },
  sections = { "error", "warn", "info", "hint" },
  symbols = {
    error = icons.diagnostics.error .. " ",
    warn = icons.diagnostics.warn .. " ",
    info = icons.diagnostics.info .. " ",
    hint = icons.diagnostics.hint .. " ",
  },
}

local treesitter = {
  function()
    return icons.misc.treesitter
  end,
  color = function()
    local buf = api.nvim_get_current_buf()
    local ts = vim.treesitter.highlighter.active[buf]
    return { fg = ts and not tbl_isempty(ts) and colors.green or colors.red }
  end,
}

local python_env = {
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
}

local lsp = {
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
}

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

local diff = {
  "diff",
  symbols = {
    added = icons.git.added .. " ",
    modified = icons.git.modified .. " ",
    removed = icons.git.deleted .. " ",
  },
  source = diff_source,
  cond = conditions.hide_in_width,
}

local location = {
  function()
    local line = fn.line(".")
    local lines = fn.line("$")
    local col = fn.virtcol(".")
    return string.format("%3d/%d:%-2d", line, lines, col)
  end,
  icon = icons.misc.milestone,
  separator = { left = icons.misc.left_half_circle_thick },
  color = { gui = "bold" },
}

local progress = {
  function()
    local current_line = fn.line(".")
    local total_lines = fn.line("$")
    local chars = icons.misc.progress
    local line_ratio = current_line / total_lines
    local index = math.ceil(line_ratio * #chars)
    return chars[index]
  end,
  color = { fg = colors.surface0 },
}

local spaces = {
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
      lualine_a = { mode },
      lualine_b = { branch },
      lualine_c = { diff, diagnostics },
      lualine_x = { python_env, lsp, treesitter, spaces, filesize },
      lualine_y = { location },
      lualine_z = { progress },
    },
    inactive_sections = {
      lualine_a = { filetype, filename },
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
