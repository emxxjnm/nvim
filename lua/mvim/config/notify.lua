local M = {}

function M.setup()
  local icons = mo.style.icons
  local notify = require("notify")

  notify.setup({
    fps = 300,
    timeout = 3200,
    stages = "slide",
    top_down = false,
    icons = {
      ERROR = icons.diagnostics.error,
      WARN = icons.diagnostics.warn,
      INFO = icons.diagnostics.info,
      DEBUG = icons.diagnostics.debug,
      TRACE = icons.diagnostics.trace,
    },
    max_width = function()
      return math.floor(vim.o.columns * 0.4)
    end,
    max_height = function()
      return math.floor(vim.o.columns * 0.8)
    end,
    render = function(...)
      local notif = select(2, ...)
      local style = notif.title[1] == "" and "minimal" or "default"
      require("notify.render")[style](...)
    end,
  })
  vim.notify = notify
end

return M
