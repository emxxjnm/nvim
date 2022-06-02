local M = {}

local sign_define = vim.fn.sign_define

function M.setup()
  local dap_status_ok, dap = pcall(require, "dap")
  if not dap_status_ok then
    return
  end

  sign_define("DapBreakpoint", {
    -- text = " ",
    text = " ",
    texthl = "LspDiagnosticsSignError",
    linehl = "",
    numhl = "",
  })
  sign_define("DapStopped", {
    text = " ",
    texthl = "LspDiagnosticsSignInformation",
    linehl = "DiagnosticUnderlineInfo",
    numhl = "LspDiagnosticsSignInformation",
  })
  sign_define("DapBreakpointRejected", {
    text = " ",
    texthl = "LspDiagnosticsSignHint",
    linehl = "",
    numhl = "",
  })

  local ui_status_ok, dapui = pcall(require, "dapui")
  if not ui_status_ok then
    return
  end

  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dap.repl.close()
    dapui.close()
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dap.repl.close()
    dapui.close()
  end

  dap.adapters.python = {
    type = "executable",
    command = "python",
    args = { "-m", "debugpy.adapter" },
  }

  require("dap.ext.vscode").load_launchjs()
end

return M
