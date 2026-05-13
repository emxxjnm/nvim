---@class mvim.util.lualine
local M = {}

local fn = vim.fn

M.conditions = {
  hide_in_width = function()
    return vim.o.columns > 100
  end,
}

M.components = {
  mode = {
    "mode",
    fmt = function(str)
      return string.sub(str, 1, 1)
    end,
    separator = {
      right = "",
      left = "",
    },
  },

  branch = {
    "branch",
    icon = { "", color = { fg = Mo.C.palette.pink, gui = "bold" } },
    color = { gui = "bold" },
  },

  filesize = {
    "filesize",
    icon = "󰙴",
    color = { fg = Mo.C.palette.lavender },
    padding = { left = 1, right = 1 },
    cond = M.conditions.hide_in_width,
  },

  diagnostics = {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    sections = { "error", "warn", "info", "hint" },
    symbols = Mo.C.icons.diagnostics,
    cond = M.conditions.hide_in_width,
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
      added = " ",
      modified = " ",
      removed = " ",
    },
    cond = M.conditions.hide_in_width,
  },

  dap = {
    function()
      return require("dap").status()
    end,
    icon = "",
    color = { fg = Mo.C.palette.yellow },
    cond = function()
      return package.loaded["dap"] and require("dap").status() ~= ""
    end,
  },

  location = {
    function()
      local line = fn.line(".")
      local lines = fn.line("$")
      local col = fn.virtcol(".")
      return string.format("%d/%d:%d", line, lines, col)
    end,
    icon = { "", color = { fg = Mo.C.palette.pink, gui = "bold" } },
    color = { gui = "bold" },
  },

  scrollbar = {
    function()
      local current_line = fn.line(".")
      local total_lines = fn.line("$")
      local chars =
        { "██", "▇▇", "▆▆", "▅▅", "▄▄", "▃▃", "▂▂", "▁▁", "  " }
      local line_ratio = current_line / total_lines
      local index = math.ceil(line_ratio * #chars)
      return chars[index]
    end,
    color = { fg = Mo.C.palette.subtle },
  },

  spaces = {
    function()
      if not vim.bo.expandtab then
        return "Tab:" .. vim.bo.tabstop
      end
      local size = vim.bo.shiftwidth
      if size == 0 then
        size = vim.bo.tabstop
      end
      return "Spaces:" .. size
    end,
    padding = { left = 1, right = 1 },
    cond = M.conditions.hide_in_width,
    color = { fg = Mo.C.palette.sapphire },
  },
}

return M
