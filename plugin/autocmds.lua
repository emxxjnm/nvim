local fn = vim.fn
local bo = vim.bo
local api = vim.api
local keymap = vim.keymap

---automatically clear commandline messages after a few seconds delay
---@return function
local function clear_commandline()
  -- Track the timer object and stop any previous thimers
  -- before setting a new one so that each change waits
  -- for 8secs and that 8secs is deferred each time
  local timer
  return function()
    if timer then
      timer:stop()
    end
    timer = vim.defer_fn(function()
      if fn.mode() == "n" then
        vim.cmd.echon("''")
      end
    end, 8000)
  end
end

mo.augroup("ClearCommandMessages", {
  {
    event = { "CmdlineLeave", "CmdlineChanged" },
    pattern = { ":" },
    command = clear_commandline(),
    desc = "automatically clear commandline messages after 8 seconds delay",
  },
})

mo.augroup("AutoSyncPlugins", {
  {
    event = "BufWritePost",
    pattern = "plugins.lua",
    command = "source <afile> | PackerSync",
    desc = "sync neovim plugins when plugins.lua is saved",
  },
})

mo.augroup("PlaceLastEdit", {
  {
    event = "BufReadPost",
    pattern = "*",
    command = function()
      if vim.bo.ft ~= "gitcommit" and vim.fn.win_gettype() ~= "popup" then
        local last_place_mark = vim.api.nvim_buf_get_mark(0, '"')
        local line_nr = last_place_mark[1]
        local last_line = vim.api.nvim_buf_line_count(0)

        if line_nr > 0 and line_nr <= last_line then
          vim.api.nvim_win_set_cursor(0, last_place_mark)
        end
      end
    end,
    desc = "when editing a file, always jump to the last know cursor position",
  },
})

mo.augroup("SmartClose", {
  {
    event = "FileType",
    pattern = { "qf", "help", "man", "lspinfo", "startuptime", "tsplayground" },
    command = function()
      local opts = { noremap = true, silent = true }
      api.nvim_buf_set_keymap(0, "n", "q", ":close<CR>", opts)
    end,
    desc = "close certain filetypes by pressing q.",
  },
  {
    event = "BufEnter",
    pattern = "*",
    nested = true,
    command = function()
      if #api.nvim_list_wins() == 1 and api.nvim_buf_get_name(0):match("NvimTree_") ~= nil then
        vim.cmd.quit()
      end
    end,
    desc = "close the tab when nvim-tree is the last window in the tab",
  },
  {
    event = "BufEnter",
    pattern = "*",
    command = function()
      if fn.winnr("$") == 1 and bo.buftype == "quickfix" then
        api.nvim_buf_delete(0, { force = true })
      end
    end,
    desc = "close quick fix window if the file containing it was closed",
  },
  {
    event = "QuitPre",
    pattern = "*",
    nested = true,
    command = function()
      if bo.filetype ~= "qf" then
        vim.cmd.lclose({ mods = { silent = true } })
      end
    end,
    desc = "automatically close corresponding loclist when quitting a window",
  },
})

mo.augroup("SetupTerminalMappings", {
  {
    event = { "TermOpen" },
    pattern = "term://*",
    command = function()
      if bo.filetype == "toggleterm" then
        local opts = { buffer = 0, silent = true }
        keymap.set("t", "jj", [[<C-\><C-n>]], opts)
        keymap.set("t", "<Esc>", [[<C-\><C-n>]], opts)
        keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
        keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], opts)
        keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], opts)
        keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], opts)
        keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], opts)
        keymap.set("t", "<leader><Tab>", "<Cmd>close \\| :bnext<CR>", opts)

        keymap.set("n", "<C-h>", [[<C-\><C-n><C-w>hi]], opts)
        keymap.set("n", "<C-j>", [[<C-\><C-n><C-w>ji]], opts)
        keymap.set("n", "<C-k>", [[<C-\><C-n><C-w>ki]], opts)
        keymap.set("n", "<C-l>", [[<C-\><C-n><C-w>li]], opts)
      end
    end,
    desc = "setup toggleterm keymap",
  },
})
