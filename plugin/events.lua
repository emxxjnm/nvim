local M = {}

local fn = vim.fn
local api = vim.api
local cmd = vim.cmd

function M.setup()
  local definitions = {
    buf = {
      {
        event = "BufWritePost",
        pattern = "plugins.lua",
        command = "source <afile> | PackerSync",
        desc = "Sync neovim plugins when plugins.lua is saved",
      },
      {
        event = "BufReadPost",
        pattern = "*",
        callback = function()
          if fn.line([['"]]) > 1 and fn.line([['"]]) <= fn.line("$") then
            cmd([[normal! g`"]])
          end
        end,
        desc = "Place to last edit",
      },
      {
        event = "BufEnter",
        pattern = "*",
        nested = true,
        callback = function()
          if #api.nvim_list_wins() == 1 and api.nvim_buf_get_name(0):match("NvimTree_") ~= nil then
            cmd("quit")
          end
        end,
        desc = "Close the tab when nvim-tree is the last window in the tab",
      },
    },
    win = {},
    ft = {
      {
        event = "FileType",
        pattern = { "qf", "help", "man", "lspinfo", "startuptime" },
        callback = function()
          local opts = { noremap = true, silent = true }
          api.nvim_buf_set_keymap(0, "n", "q", ":close<cr>", opts)
        end,
      },
    },
  }

  for name, definition in pairs(definitions) do
    if not vim.tbl_isempty(definition) then
      local group = api.nvim_create_augroup(name, { clear = true })
      for _, def in ipairs(definition) do
        api.nvim_create_autocmd({ def.event }, {
          group = group,
          pattern = def.pattern,
          command = def.command,
          callback = def.callback,
          nested = def.nested or false,
          once = def.once or false,
          desc = def.desc,
        })
      end
    end
  end
end

M.setup()
