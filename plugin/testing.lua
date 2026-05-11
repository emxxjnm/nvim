local load_neotest = Mo.once(function()

  vim.pack.add({
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/nvim-neotest/nvim-nio",
    "https://github.com/nvim-neotest/neotest",
    "https://github.com/nvim-neotest/neotest-go",
    "https://github.com/nvim-neotest/neotest-python",
  })

  require("neotest").setup({
    output = { open_on_run = true },
    floating = {
      border = Mo.C.border,
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
      require("neotest-go"),
      require("neotest-python")({
        dap = {
          justMyCode = false,
          console = "integratedTerminal",
          subProcess = false,
        },
        pytest_discovery = true,
      }),
    },
  })
end)

-- stylua: ignore start
vim.keymap.set("n", "<leader>ts", function() load_neotest(); require("neotest").summary.toggle() end, { desc = "Toggle summary" })
vim.keymap.set("n", "<leader>ta", function() load_neotest(); require("neotest").run.attach() end, { desc = "Attach" })
vim.keymap.set("n", "<leader>tp", function() load_neotest(); require("neotest").output_panel.toggle() end, { desc = "Toggle output panel" })
vim.keymap.set("n", "<leader>to", function() load_neotest(); require("neotest").output.open({ enter = true, auto_close = true }) end, { desc = "Show output" })
vim.keymap.set("n", "<leader>tr", function() load_neotest(); require("neotest").run.run() end, { desc = "Run" })
vim.keymap.set("n", "<leader>tl", function() load_neotest(); require("neotest").run.run_last() end, { desc = "Run last" })
vim.keymap.set("n", "<leader>tf", function() load_neotest(); require("neotest").run.run(vim.fn.expand("%")) end, { desc = "Run file" })
vim.keymap.set("n", "<leader>tx", function() load_neotest(); require("neotest").run.stop() end, { desc = "Stop" })
vim.keymap.set("n", "[t", function() load_neotest(); require("neotest").jump.prev({ status = "failed" }) end, { desc = "Prev failed test" })
vim.keymap.set("n", "]t", function() load_neotest(); require("neotest").jump.next({ status = "failed" }) end, { desc = "Next failed test" })
-- stylua: ignore end
