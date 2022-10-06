local M = {}

function M.setup()
  local fn = vim.fn

  fn.sign_define("DapBreakpoint", {
    text = mo.style.icons.dap.breakpoint,
    texthl = "DapBreakpoint",
    linehl = "",
    numhl = "",
  })
  fn.sign_define("DapStopped", {
    text = mo.style.icons.dap.stopped,
    texthl = "DapStopped",
    linehl = "",
    numhl = "DapStopped",
  })
end

function M.config()
  local dap = require("dap")
  dap.adapters.python = {
    type = "executable",
    command = "python",
    args = { "-m", "debugpy.adapter" },
  }
  require("dap.ext.vscode").load_launchjs()

  local map = vim.keymap.set
  map("n", "<leader>b", dap.toggle_breakpoint, {
    silent = true,
    desc = "dap: create or remove a breakpoint",
  })
  map("n", "<F5>", dap.continue, {
    silent = true,
    desc = "",
  })
  map("n", "<S-F5>", dap.terminate, {
    silent = true,
    desc = "dap: terminates the debug session",
  })
  map("n", "<F6>", dap.pause, {
    silent = true,
    desc = "dap: requests debug adapter to pause a thread",
  })
  map("n", "<F10>", dap.step_over, {
    silent = true,
    desc = "dap: requests the debugee to run again for one step",
  })
  map("n", "<F11>", dap.step_into, {
    silent = true,
    desc = "dap: requests the debugee to step into a function or method",
  })
  map("n", "<F12>", dap.step_out, {
    silent = true,
    desc = "dap: requests the debugee to step out of a function or method",
  })
end

return M
