local M = {}

local sign_define = vim.fn.sign_define

function M.setup()
  local dap_status_ok, dap = pcall(require, "dap")
  if not dap_status_ok then
    return
  end

  sign_define("DapBreakpoint", {
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

  dap.adapters.python = {
    type = "executable",
    command = "python",
    args = { "-m", "debugpy.adapter" },
  }

  require("dap.ext.vscode").load_launchjs()
end

return M
