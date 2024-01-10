---@class mvim.util.lualine
local M = {}

local fn, api = vim.fn, vim.api
local palette = require("mvim.config").palette

M.conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
  end,
  hide_in_width = function()
    return vim.o.columns > 100
  end,
  has_lsp_clients = function()
    local clients = vim.lsp.get_active_clients({ bufnr = 0 })
    return #clients > 0
  end,
}

M.components = {
  mode = {
    "mode",
    fmt = function(str)
      return string.sub(str, 1, 1)
    end,
    separator = {
      right = "",
      left = "",
    },
  },

  branch = {
    "branch",
    icon = { "", color = { fg = palette.pink, gui = "bold" } },
    color = { gui = "bold" },
    separator = {
      right = "",
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
    color = { fg = palette.lavender },
  },

  filesize = {
    "filesize",
    icon = "󰙴",
    color = { fg = palette.lavender },
    padding = { left = 0, right = 1 },
    cond = M.conditions.buffer_not_empty and M.conditions.hide_in_width,
  },

  diagnostics = {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    sections = { "error", "warn", "info", "hint" },
    symbols = require("mvim.config").icons.diagnostics,
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
      added = " ",
      modified = " ",
      removed = " ",
    },
    cond = M.conditions.hide_in_width,
  },

  treesitter = {
    function()
      return ""
    end,
    color = function()
      local buf = api.nvim_get_current_buf()
      local ts = vim.treesitter.highlighter.active[buf]
      return {
        fg = ts and not vim.tbl_isempty(ts) and palette.green or palette.red,
      }
    end,
    cond = M.conditions.hide_in_width,
  },

  python_env = {
    function()
      if vim.bo.filetype == "python" then
        local venv = vim.env.VIRTUAL_ENV
        if venv then
          local venv_name = fn.fnamemodify(venv, ":t")
          return string.format("(%s)", venv_name)
        end
      end
      return ""
    end,
    -- icon = function()
    --   local devicons = require("nvim-web-devicons")
    --   local icon, color = devicons.get_icon_color_by_filetype("python")
    --   return { icon, color = { fg = color } }
    -- end,
    icon = { "󰌠", color = { fg = "#ffbc03" } },
    color = { fg = palette.lavender },
    cond = M.conditions.hide_in_width,
  },

  lsp = {
    function()
      local clients = {}
      local buf_clients = vim.lsp.get_active_clients({ bufnr = 0 })
      for _, client in pairs(buf_clients) do
        table.insert(clients, client.name)
      end

      return string.format("LSP(s):[%s]", table.concat(clients, " • "))
    end,
    icon = "",
    color = { fg = palette.mauve },
    cond = M.conditions.hide_in_width and M.conditions.has_lsp_clients,
  },

  lsp_progress = {
    function()
      if not rawget(vim, "lsp") or vim.lsp.status then
        return ""
      end

      local progress = vim.lsp.util.get_progress_messages()[1]

      if progress.done then
        vim.defer_fn(function()
          vim.cmd.redrawstatus()
        end, 1000)
      end

      local msg = progress.message or ""
      local percentage = progress.percentage or 0
      local title = progress.title or ""
      local ms = vim.loop.hrtime() / 1000000
      local spinners = { "", "󰪞", "󰪟", "󰪠", "󰪢", "󰪣", "󰪤", "󰪥" }
      local frame = math.floor(ms / 120) % #spinners
      local content =
        string.format(" %%<%s %s %s(%s%%%%) ", spinners[frame + 1], title, msg, percentage)

      return content or ""
    end,
    color = { fg = palette.overlay0 },
    cond = M.conditions.hide_in_width,
  },

  dap = {
    function()
      return require("dap").status()
    end,
    icon = "",
    color = { fg = palette.yellow },
    cond = function()
      return package.loaded["dap"] and require("dap").status() ~= ""
    end,
  },

  lazy = {
    require("lazy.status").updates,
    color = { fg = palette.subtext0 },
    cond = require("lazy.status").has_updates,
  },

  location = {
    function()
      local line = fn.line(".")
      local lines = fn.line("$")
      local col = fn.virtcol(".")
      -- return string.format("%3d/%d:%-2d", line, lines, col)
      return string.format("%d/%d:%d", line, lines, col)
    end,
    icon = { "", color = { fg = palette.pink, gui = "bold" } },
    separator = { left = "" },
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
    color = { fg = palette.surface0 },
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
    cond = M.conditions.hide_in_width,
    color = { fg = palette.sapphire },
  },

  clock = {
    function()
      return os.date("%R")
    end,
    icon = "",
    separator = {
      right = "",
      left = "",
    },
  },
}

return M
