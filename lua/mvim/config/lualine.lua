local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
  return
end

local fn = vim.fn
local bo = vim.bo
local api = vim.api
local lsp = vim.lsp
local sitter = vim.treesitter
local list_extend = vim.list_extend

local next = next

local conditions = {
  buffer_not_empty = function()
    return fn.empty(fn.expand("%:t")) ~= 1
  end,
  hide_in_width = function()
    return fn.winwidth(0) > 80
  end,
}

local colors = {
  blue = "#87b0f9",
  lavender = "#b4befe",
  maroon = "#eba0ac",
  mauve = "#cba6f7",
  green = "#a6e3a1",
}

local mode = {
  "mode",
  fmt = function(str)
    return " " .. string.sub(str, 1, 1) .. " "
  end
}

local branch = {
  "branch",
  separator = { right = "" },
  color = { gui = "bold" },
}

local filename = {
  "filename",
  file_status = true, -- Displays file status (readonly status, modified status)
  path = 0, -- 0: Just the filename 1: Relative path 2: Absolute path
  color = { fg = colors.lavender },
}

local filesize = {
  "filesize",
  icon = "",
  color = { fg = colors.lavender },
  condition = conditions.buffer_not_empty,
}

local diagnostics = {
  "diagnostics",
  sources = { "nvim_diagnostic", "nvim_lsp" },
  sections = { "error", "warn", "info" },
  symbols = { error = " ", warn = " ", info = " " },
  always_visible = true,
}

local treesitter = {
  function()
    local buf = api.nvim_get_current_buf()
    if next(sitter.highlighter.active[buf]) then
      return ''
    end
    return ""
  end,
  color = { fg = colors.green },
}

local lanuage_server = {
  function(msg)
    msg = msg or "Inactive"
    local buf_clients = lsp.buf_get_clients()
    if next(buf_clients) == nil then
      -- TODO: clean up this if statement
      if type(msg) == "boolean" or #msg == 0 then
        return "Unknown"
      end
      return msg
    end

    local buf_ft = bo.filetype
    local buf_client_names = {}

    -- add client
    for _, client in pairs(buf_clients) do
      if client.name ~= "null-ls" then
        table.insert(buf_client_names, client.name)
      end
    end

    -- add formatter
    local formatters = require "mvim.lsp.extension.formatters"
    local supported_formatters = formatters.list_registered(buf_ft)
    list_extend(buf_client_names, supported_formatters)

    -- add linter
    local linters = require "mvim.lsp.extension.linters"
    local supported_linters = linters.list_registered(buf_ft)
    list_extend(buf_client_names, supported_linters)

    local clients = fn.uniq(buf_client_names)
    return " LSP: " .. table.concat(clients, " │ ")
  end,
  color = { fg = colors.blue, gui = 'bold' },
  cond = conditions.hide_in_width,
}

local diff = {
  "diff",
  symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
  cond = conditions.hide_in_width
}

local location = {
  "location",
  separator = { left = "" },
}

-- cool function for progress
local progress = function()
  local current_line = fn.line(".")
  local total_lines = fn.line("$")
  local chars = { "██", "▇▇", "▆▆", "▅▅", "▄▄", "▃▃", "▂▂", "▁▁", "  ", }
  local line_ratio = current_line / total_lines
  local index = math.ceil(line_ratio * #chars)
  return chars[index]
end

local spaces = {
  function()
    if not api.nvim_buf_get_option(0, "expandtab") then
      return "Tabs:" .. api.nvim_buf_get_option(0, "tabstop")
    end
    local size = api.nvim_buf_get_option(0, "shiftwidth")
    if size == 0 then
      size = api.nvim_buf_get_option(0, "tabstop")
    end
    return "Spaces:" .. size
  end,
  cond = conditions.hide_in_width,
  color = { fg = colors.maroon },
}

local filetype = {
  "filetype",
  color = { fg = colors.mauve },
}

lualine.setup({
  options = {
    icons_enabled = true,
    theme = "catppuccin",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = {
      "alpha",
      "packer",
      "NvimTree",
      "dap-repl",
      "dapui_stacks",
      "dapui_scopes",
      "dapui_watches",
      "dapui_breakpoints",
    },
    -- always_divide_middle = true,
  },
  sections = {
    lualine_a = { mode },
    lualine_b = { branch },
    lualine_c = { filename, diff, diagnostics },
    lualine_x = { lanuage_server, treesitter, spaces, filesize, filetype },
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
  extensions = {},
})
