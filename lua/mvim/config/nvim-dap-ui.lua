local M = {}

local icons = mo.style.icons

local config = {
  icons = {
    expanded = icons.documents.expanded,
    collapsed = icons.documents.collapsed,
    current_frame = icons.documents.collapsed,
  },
  mappings = {
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  expand_lines = true,
  layouts = {
    {
      elements = {
        "scopes",
        "breakpoints",
        "stacks",
        "watches",
      },
      size = 0.3,
      position = "right",
    },
    {
      elements = {
        "repl",
      },
      size = 12,
      position = "bottom",
    },
  },
  controls = {
    enabled = true,
    element = "repl",
    icons = {
      pause = icons.dap.pause,
      play = icons.dap.play,
      step_into = icons.dap.step_into,
      step_over = icons.dap.step_over,
      step_out = icons.dap.step_out,
      step_back = icons.dap.step_back,
      run_last = icons.dap.restart,
      terminate = icons.dap.stop,
    },
  },
  floating = {
    max_height = nil,
    max_width = nil,
    border = "single",
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 2 },
  render = {
    max_type_length = nil,
    max_value_lines = 100,
  },
}

function M.setup()
  local dap = require("dap")
  local dapui = require("dapui")

  dapui.setup(config)

  dap.listeners.after.event_initialized["dapui_config"] = function()
    local breakpoints = require("dap.breakpoints").get()
    if vim.tbl_isempty(breakpoints) then
      dap.repl.open({ height = 12 })
    else
      dapui.open()
    end
  end

  dap.listeners.before.event_stopped["dapui_config"] = function(_, body)
    if body.reason == "breakpoint" then
      dapui.open()
    end
  end

  dap.listeners.before.event_terminated["dapui_config"] = function()
    dap.repl.close()
    dapui.close()
  end

  dap.listeners.before.event_exited["dapui_config"] = function()
    dap.repl.close()
    dapui.close()
  end
end

return M
