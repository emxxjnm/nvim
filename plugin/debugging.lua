local load_dap = Mo.once(function()

  vim.pack.add({
    "https://github.com/nvim-neotest/nvim-nio",
    "https://github.com/mfussenegger/nvim-dap",
    "https://github.com/rcarriga/nvim-dap-ui",
    "https://github.com/theHamsta/nvim-dap-virtual-text",
  })

  local dap = require("dap")
  local dapui = require("dapui")

  dap.defaults.fallback.sign_priority = {
    breakpoint = 10,
    stopped = 20,
  }

  vim.fn.sign_define("DapStopped", { text = "󰋇 ", texthl = "DapStopped", numhl = "DapStopped" })
  vim.fn.sign_define("DapBreakpoint", { text = "󰄛 ", texthl = "DapBreakpoint", numhl = "DapBreakpoint" })

  -- nvim-dap-virtual-text
  require("nvim-dap-virtual-text").setup({ highlight_new_as_changed = true })

  -- dap-ui
  dapui.setup({
    icons = {
      expanded = "",
      collapsed = "",
      current_frame = "",
    },
    layouts = {
      {
        elements = { "scopes", "stacks", "watches", "breakpoints" },
        size = 0.3,
        position = "right",
      },
      {
        elements = { "repl" },
        size = 0.24,
        position = "bottom",
      },
    },
    floating = { border = Mo.C.border },
  })

  dap.listeners.after.event_initialized["dapui_config"] = function()
    local breakpoints = require("dap.breakpoints").get()
    local args = vim.tbl_isempty(breakpoints) and {} or { layout = 2 }
    dapui.open(args)
  end
  dap.listeners.before.event_stopped["dapui_config"] = function(_, body)
    if body.reason == "breakpoint" then
      dapui.open({})
    end
  end

  -- adapters
  dap.adapters.python = {
    type = "executable",
    command = "python",
    args = { "-m", "debugpy.adapter" },
    options = { source_filetype = "python" },
  }

  dap.adapters.go = {
    type = "server",
    port = "${port}",
    executable = {
      command = "dlv",
      args = { "dap", "-l", "127.0.0.1:" .. "${port}" },
    },
    options = { initialize_timeout_sec = 10 },
  }

  vim.api.nvim_create_autocmd("BufWinEnter", {
    pattern = { "\\[dap-repl\\]", "DAP *" },
    callback = vim.schedule_wrap(function(args)
      local win = vim.fn.bufwinid(args.buf)
      vim.wo[win].wrap = true
    end),
  })
end)

-- stylua: ignore start
vim.keymap.set("n", "<leader>db", function() load_dap(); require("dap").toggle_breakpoint() end, { desc = "Toggle breakpoint" })
vim.keymap.set("n", "<leader>dc", function() load_dap(); require("dap").continue() end, { desc = "Continue" })
vim.keymap.set("n", "<leader>dC", function() load_dap(); require("dap").run_to_cursor() end, { desc = "Run to Cursor" })
vim.keymap.set("n", "<leader>dt", function() load_dap(); require("dap").terminate() end, { desc = "Terminate" })
vim.keymap.set("n", "<leader>dr", function() load_dap(); require("dap").restart() end, { desc = "Restart" })
vim.keymap.set("n", "<leader>dp", function() load_dap(); require("dap").pause() end, { desc = "Pause" })
vim.keymap.set("n", "<leader>di", function() load_dap(); require("dap").step_into() end, { desc = "Step into" })
vim.keymap.set("n", "<leader>do", function() load_dap(); require("dap").step_out() end, { desc = "Step out" })
vim.keymap.set("n", "<leader>dO", function() load_dap(); require("dap").step_over() end, { desc = "Step over" })
vim.keymap.set("n", "<leader>du", function() load_dap(); require("dapui").toggle() end, { desc = "Toggle DAP UI" })
-- stylua: ignore end
