local M = {}

local config = {
  icons = { expanded = "", collapsed = "" },
  mappings = {
    expand = { "<CR>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  layouts = {
    {
      elements = {
        { id = "scopes", size = 0.25 },
        "breakpoints",
        "stacks",
        "watches",
      },
      size = 40,
      position = "right",
    },
    {
      elements = {
        "repl",
        -- "console",
      },
      size = 10,
      position = "bottom",
    },
  },
  expand_lines = true,
  floating = {
    max_height = nil,
    max_width = nil,
    border = "single",
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
  render = {
    max_type_length = nil,
  },
}

function M.setup()
  local ui_ok, dapui = pcall(require, "dapui")
  if not ui_ok then
    return
  end

  dapui.setup(config)

  local dap_ok, dap = pcall(require, "dap")
  if not dap_ok then
    return
  end

  dap.listeners.after["event_initialized"]["dapui_config"] = function()
    local breakpoints = require("dap.breakpoints").get()
    if vim.tbl_isempty(breakpoints) then
      dap.repl.open({ height = 10 })
    else
      dapui.open()
    end
  end
  dap.listeners.before["event_stopped"]["dapui_config"] = function(_, body)
    if body.reason == "breakpoint" then
      dapui.open()
    end
  end
  dap.listeners.before["event_terminated"]["dapui_config"] = function()
    dap.repl.close()
    dapui.close()
  end
  dap.listeners.before["event_exited"]["dapui_config"] = function()
    dap.repl.close()
    dapui.close()
  end
end

return M
