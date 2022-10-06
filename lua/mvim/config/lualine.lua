local M = {}

local colors = require("catppuccin.palettes").get_palette() or {}
local icons = mo.style.icons

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
    return " " .. string.sub(str, 1, 1) .. " "
  end,
}

local branch = {
  "branch",
  icon = icons.git.branch,
  color = { gui = "bold" },
}

local filename = {
  "filename",
  file_status = false,
  color = { fg = colors.lavender },
}

local filesize = {
  "filesize",
  icon = icons.misc.creation,
  color = { fg = colors.lavender },
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
    return icons.misc.lsp .. " LSP:" .. table.concat(clients, "┇")
  end,
  color = { fg = colors.mauve },
  cond = conditions.hide_in_width,
}

local diff = {
  "diff",
  symbols = {
    added = icons.git.added .. " ",
    modified = icons.git.modified .. " ",
    removed = icons.git.deleted .. " ",
  },
  cond = conditions.hide_in_width,
}

local location = {
  "location",
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
}

local spaces = {
  function()
    if not api.nvim_buf_get_option(0, "expandtab") then
      return "Tab:" .. api.nvim_buf_get_option(0, "tabstop")
    end
    local size = api.nvim_buf_get_option(0, "shiftwidth")
    if size == 0 then
      size = api.nvim_buf_get_option(0, "tabstop")
    end
    return "SP:" .. size
  end,
  cond = conditions.hide_in_width,
  color = { fg = colors.sapphire },
}

local filetype = {
  "filetype",
  icon_only = true,
  padding = { right = 2, left = 1 },
}

function M.setup()
  require("lualine").setup({
    options = {
      icons_enabled = true,
      theme = "catppuccin",
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
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
      lualine_c = { filename, diff, diagnostics },
      lualine_x = { lsp, treesitter, spaces, filesize, filetype },
      lualine_y = { location },
      lualine_z = { progress },
    },
    inactive_sections = {
      lualine_a = { filename },
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
