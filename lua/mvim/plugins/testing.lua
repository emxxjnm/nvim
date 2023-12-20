return {
  {
    "nvim-neotest/neotest",
    keys = {
      {
        "<leader>ns",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Toggle summary",
      },
      {
        "<leader>na",
        function()
          require("neotest").run.attach()
        end,
        desc = "Attach",
      },
      {
        "<leader>np",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "Toggle output panel",
      },
      {
        "<leader>no",
        function()
          require("neotest").output.open({
            enter = true,
            auto_close = true,
          })
        end,
        desc = "Show output",
      },
      {
        "<leader>nn",
        function()
          require("neotest").run.run()
        end,
        desc = "Run",
      },
      {
        "<leader>nl",
        function()
          require("neotest").run.run_last()
        end,
        desc = "Run last",
      },
      {
        "<leader>nf",
        function()
          require("neotest").run.run({ vim.fn.expand("%:p") })
        end,
        desc = "Run file",
      },
      {
        "<leader>nx",
        function()
          require("neotest").run.stop()
        end,
        desc = "Stop",
      },
      {
        "[n",
        function()
          require("neotest").jump.prev({ status = "failed" })
        end,
        desc = "Next failed test",
      },
      {
        "]n",
        function()
          require("neotest").jump.next({ status = "failed" })
        end,
        desc = "Prev failed test",
      },
    },
    dependencies = {
      "nvim-neotest/neotest-go",
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-plenary",
    },
    opts = function()
      return {
        output = {
          open_on_run = true,
        },
        floating = {
          border = mo.styles.border,
          max_height = 0.6,
          max_width = 0.8,
        },
        consumers = {
          always_open_output = function(client)
            local async = require("neotest.async")
            client.listeners.results = function(adapter_id, results)
              local file_path = async.fn.expand("%:p")
              local row = async.fn.getpos(".")[2] - 1
              local position = client:get_nearest(file_path, row, {})
              if not position then
                return
              end
              local pos_id = position:data().id
              if not results[pos_id] then
                return
              end
              require("neotest").output.open({ position_id = pos_id, adapter = adapter_id })
            end
            return client
          end,
        },
        adapters = {
          require("neotest-python")({
            dap = { justMyCode = false, console = "integratedTerminal", subProcess = false },
            pytest_discovery = true,
          }),
          require("neotest-go"),
          require("neotest-plenary"),
        },
      }
    end,
  },
}
