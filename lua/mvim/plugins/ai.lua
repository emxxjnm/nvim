return {
  "CopilotC-Nvim/CopilotChat.nvim",
  branch = "main",
  cmd = "CopilotChat",
  build = "make tiktoken",
  opts = function()
    local user = vim.env.USER or "User"
    user = user:sub(1, 1):upper() .. user:sub(2)
    return {
      insert_at_end = true,
      question_header = "   " .. user .. " ",
      answer_header = "   Copilot ",
      window = { width = 0.4 },
      mappings = {
        submit_prompt = {
          normal = "<CR>",
          insert = "<C-CR>",
        },
      },
    }
  end,
  keys = {
    {
      "<leader>ai",
      function()
        return require("CopilotChat").toggle()
      end,
      desc = "Toggle Chat",
      mode = { "n", "v" },
    },
    {
      "<leader>ax",
      function()
        return require("CopilotChat").reset()
      end,
      desc = "Clear Chat",
      mode = { "n", "v" },
    },
    {
      "<leader>aq",
      function()
        local input = vim.fn.input("Ask Copilot: ")
        if input ~= "" then
          require("CopilotChat").ask(input)
        end
      end,
      desc = "Quick Chat",
      mode = { "n", "v" },
    },
    {
      "<leader>ap",
      function()
        require("CopilotChat").select_prompt()
      end,
      desc = "Prompt Actions",
      mode = { "n", "v" },
    },
  },
  config = function(_, opts)
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "copilot-*",
      callback = function()
        vim.opt_local.number = false
        vim.opt_local.signcolumn = "no"
        vim.opt_local.relativenumber = false
      end,
    })

    require("CopilotChat").setup(opts)
  end,
}
