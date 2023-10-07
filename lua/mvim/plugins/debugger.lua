-- stop: shift + F5; restart: command + shift + F5
local M = {
  "mfussenegger/nvim-dap",
  keys = {
    {
      "<leader>db",
      function()
        require("dap").toggle_breakpoint()
      end,
      desc = "Toggle breakpoint",
    },
    {
      "<F5>",
      function()
        require("dap").continue()
      end,
      desc = "Continue",
    },
    {
      "<F17>", -- shift + F5
      function()
        require("dap").terminate()
      end,
      desc = "Terminate",
    },
    {
      "<S-F5>", -- command + shift + F5
      function()
        require("dap").restart()
      end,
      desc = "Restart",
    },
    {
      "<F6>",
      function()
        require("dap").pause()
      end,
      desc = "Pause",
    },
    {
      "<F10>",
      function()
        require("dap").step_over()
      end,
      desc = "Step over",
    },
    {
      "<F11>",
      function()
        require("dap").step_into()
      end,
      desc = "Step into",
    },
    {
      "<F12>",
      function()
        require("dap").step_out()
      end,
      desc = "Step out",
    },
  },
  dependencies = {
    {
      "rcarriga/nvim-dap-ui",
      keys = {
        {
          "<leader>du",
          function()
            require("dapui").toggle()
          end,
          desc = "Toggle DAP UI",
        },
      },
      opts = {
        icons = {
          expanded = I.documents.expanded,
          collapsed = I.documents.collapsed,
          current_frame = I.documents.collapsed,
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
            elements = { "repl" },
            size = 0.24,
            position = "bottom",
          },
        },
        controls = {
          icons = I.dap.controls,
        },
        floating = {
          border = mo.styles.border,
        },
      },
      config = function(_, opts)
        -- setup listener
        local dap, dapui = require("dap"), require("dapui")

        dapui.setup(opts)

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
        -- dap.listeners.before.event_terminated["dapui_config"] = function()
        --   dapui.close({})
        -- end
        -- dap.listeners.before.event_exited["dapui_config"] = function()
        --   dapui.close({})
        -- end
      end,
    },
    {
      "theHamsta/nvim-dap-virtual-text",
      opts = { highlight_new_as_changed = true },
    },
  },
  init = function()
    for name, icon in pairs(I.dap.signs) do
      name = "Dap" .. name:gsub("^%l", string.upper)
      vim.fn.sign_define(name, { text = icon, texthl = name, numhl = name })
    end
  end,
  config = function()
    -- load launch.json file
    require("dap.ext.vscode").load_launchjs(
      vim.fn.getcwd() .. "/" .. mo.settings.metadir .. "/launch.json"
    )

    local dap = require("dap")
    -- setup adapter
    dap.adapters.python = {
      type = "executable",
      command = "python",
      args = { "-m", "debugpy.adapter" },
      options = {
        source_filetype = "python",
      },
    }

    dap.adapters.go = {
      type = "server",
      port = "${port}",
      executable = {
        command = "dlv",
        args = { "dap", "-l", "127.0.0.1:" .. "${port}" },
      },
      options = {
        initialize_timeout_sec = 10,
      },
    }

    -- https://github.com/rcarriga/nvim-dap-ui/issues/248
    require("mvim.utils").augroup("DapReplOptions", {
      event = "BufWinEnter",
      pattern = { "\\[dap-repl\\]", "DAP *" },
      command = vim.schedule_wrap(function(args)
        local win = vim.fn.bufwinid(args.buf)
        vim.api.nvim_win_set_option(win, "wrap", true)
        -- vim.api.nvim_win_set_option(win, "statuscolumn", "")
      end),
    })
  end,
}

return M
