local icons = mo.style.icons

local M = {
  "mfussenegger/nvim-dap",
  module = "dap",
  dependencies = {
    {
      "rcarriga/nvim-dap-ui",
      init = function()
        local dap = require("dap")
        local dapui = require("dapui")

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
      end,
      config = function()
        require("dapui").setup({
          icons = {
            expanded = icons.documents.expanded,
            collapsed = icons.documents.collapsed,
            current_frame = icons.documents.collapsed,
          },
          layouts = {
            {
              elements = {
                "scopes",
                "stacks",
                "watches",
                "breakpoints",
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
            border = mo.style.border.current,
          },
        })
      end,
    },
    {
      "theHamsta/nvim-dap-virtual-text",
      opts = { highlight_new_as_changed = true },
    },
  },
}

function M.init()
  local keymap = vim.keymap.set
  local dap = require("dap")

  vim.fn.sign_define({
    {
      name = "DapBreakpoint",
      text = icons.dap.breakpoint,
      texthl = "DapBreakpoint",
    },
    {
      name = "DapStopped",
      text = icons.dap.stopped,
      texthl = "DapStopped",
      numhl = "DapStopped",
    },
  })

  keymap("n", "<leader>b", dap.toggle_breakpoint, {
    silent = true,
    desc = "dap: create or remove a breakpoint",
  })
  keymap("n", "<F5>", dap.continue, {
    silent = true,
    desc = "",
  })
  keymap("n", "<S-F5>", dap.terminate, {
    silent = true,
    desc = "dap: terminates the debug session",
  })
  keymap("n", "<F6>", dap.pause, {
    silent = true,
    desc = "dap: requests debug adapter to pause a thread",
  })
  keymap("n", "<F10>", dap.step_over, {
    silent = true,
    desc = "dap: requests the debugee to run again for one step",
  })
  keymap("n", "<F11>", dap.step_into, {
    silent = true,
    desc = "dap: requests the debugee to step into a function or method",
  })
  keymap("n", "<F12>", dap.step_out, {
    silent = true,
    desc = "dap: requests the debugee to step out of a function or method",
  })

  require("dap.ext.vscode").load_launchjs(
    vim.fn.getcwd() .. "/" .. mo.config.metadir .. "/launch.json"
  )
end

function M.config()
  local dap = require("dap")

  dap.adapters.python = {
    type = "executable",
    command = "python",
    args = { "-m", "debugpy.adapter" },
  }
end

return M
