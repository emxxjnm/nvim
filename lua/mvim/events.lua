local M = {}

local next = next
local cmd = vim.cmd
local list_wins = vim.api.nvim_list_wins
local get_buf_name = vim.api.nvim_buf_get_name
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local buf_keymap = vim.api.nvim_buf_set_keymap

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
        command = [[if line("'\"") > 1 && line("'\"") <= line("$") | execute 'normal! g`"' | endif]],
        desc = "Place to last edit",
      },
      {
        event = "BufEnter",
        pattern = "*",
        nested = true,
        callback = function()
          if #list_wins() == 1 and get_buf_name(0):match("NvimTree_") ~= nil then
            cmd("quit")
          end
        end,
        desc = "Close the tab when nvim-tree is the last window in the tab",
      }
    },
    win = {},
    ft = {
      {
        event = "FileType",
        pattern = { "qf", "help", "man", "lspinfo", "startuptime" },
        callback = function()
          local opts = { noremap = true, silent = true }
          buf_keymap(0, "n", "q", ":close<cr>", opts)
        end
      },
    },
  }

  for name, definition in pairs(definitions) do
    if next(definition) then
      local group = augroup(name, { clear = true })
      for _, def in ipairs(definition) do
        autocmd(
          { def.event },
          {
            group = group,
            pattern = def.pattern,
            command = def.command,
            callback = def.callback,
            nested = def.nested or false,
            once = def.once or false,
            desc = def.desc,
          }
        )
      end
    end
  end
end

M.setup()
