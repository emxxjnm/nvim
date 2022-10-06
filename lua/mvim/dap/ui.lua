local M = {}

local config = {
  icons = {
    expanded = mo.style.icons.documents.expanded,
    collapsed = mo.style.icons.documents.collapsed,
  },
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
  expand_lines = true,
  floating = {
    max_height = nil,
    max_width = nil,
    border = "none",
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
  local dap = require("dap")
  local dapui = require("dapui")

  dapui.setup(config)

  dap.listeners.after.event_initialized["dapui_config"] = function()
    local breakpoints = require("dap.breakpoints").get()
    if vim.tbl_isempty(breakpoints) then
      dap.repl.open({ height = 12 })
    else
      dapui.open({})
    end
  end

  dap.listeners.before.event_stopped["dapui_config"] = function(_, body)
    if body.reason == "breakpoint" then
      dapui.open({})
    end
  end

  dap.listeners.before.event_terminated["dapui_config"] = function()
    dap.repl.close()
    dapui.close({})
  end

  dap.listeners.before.event_exited["dapui_config"] = function()
    dap.repl.close()
    dapui.close({})
  end
end

return M
