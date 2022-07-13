local M = {}

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
    return fn.winwidth(0) > 80
  end,
}

-- catppuccin::macchiato
local colors = {
  blue = "#8aadf4",
  lavender = "#b7bdf8",
  sapphire = "#7dc4e4",
  mauve = "#c6a0f6",
  green = "#a6da95",
  red = "#ed8796",
}

local mode = {
  "mode",
  fmt = function(str)
    return " " .. string.sub(str, 1, 1) .. " "
  end,
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
  sources = { "nvim_diagnostic" },
  sections = { "error", "warn", "info" },
  symbols = { error = " ", warn = " ", info = " " },
  always_visible = true,
}

local treesitter = {
  function()
    return ""
  end,
  color = function()
    local buf = api.nvim_get_current_buf()
    local ts = vim.treesitter.highlighter.active[buf]
    return { fg = ts and not tbl_isempty(ts) and colors.green or colors.red }
  end,
}

local lsp = {
  function()
    local buf_clients = vim.lsp.buf_get_clients()
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
    return " LSP:" .. table.concat(clients, "│")
  end,
  color = { fg = colors.blue, gui = "bold" },
  cond = conditions.hide_in_width,
}

local diff = {
  "diff",
  symbols = { added = " ", modified = " ", removed = " " },
  cond = conditions.hide_in_width,
}

local location = {
  "location",
  separator = { left = "" },
}

local progress = {
  function()
    local current_line = fn.line(".")
    local total_lines = fn.line("$")
    local chars = { "██", "▇▇", "▆▆", "▅▅", "▄▄", "▃▃", "▂▂", "▁▁", "  " }
    local line_ratio = current_line / total_lines
    local index = math.ceil(line_ratio * #chars)
    return chars[index]
  end,
}

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
  color = { fg = colors.sapphire },
}

local filetype = {
  "filetype",
  color = { fg = colors.mauve },
}

function M.setup()
  require("lualine").setup({
    options = {
      icons_enabled = true,
      theme = "catppuccin",
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      disabled_filetypes = {
        "alpha",
        "packer",
        "NvimTree",
        "toggleterm",
        "dap-repl",
        "dapui_stacks",
        "dapui_scopes",
        "dapui_watches",
        "dapui_breakpoints",
        "TelescopePrompt",
      },
      -- always_divide_middle = true,
      -- globalstatus = true,
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
    extensions = {},
  })
end

return M
