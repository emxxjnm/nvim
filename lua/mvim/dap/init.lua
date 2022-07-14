local M = {}

function M.setup()
  local dap = require("dap")
  local sign_define = vim.fn.sign_define

  sign_define("DapBreakpoint", {
    text = "",
    texthl = "DiagnosticSignError",
    linehl = "",
    numhl = "",
  })
  sign_define("DapStopped", {
    text = "",
    texthl = "DiagnosticSignInfo",
    linehl = "",
    numhl = "DiagnosticSignInfo",
  })

  dap.adapters.python = {
    type = "executable",
    command = "python",
    args = { "-m", "debugpy.adapter" },
  }

  require("dap.ext.vscode").load_launchjs()
end

return M
