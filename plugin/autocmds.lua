local fn = vim.fn
local bo = vim.bo
local api = vim.api
local cmd = vim.cmd

---@class Autocommand
---@field desc string
---@field event  string[] list of autocommand events
---@field pattern string[] list of autocommand patterns
---@field command string | function
---@field nested  boolean
---@field once    boolean
---@field buffer  number

---Create an autocommand
---@param name string
---@param commands Autocommand[]
local function augroup(name, commands)
  local group = api.nvim_create_augroup(name, {})
  for _, autocmd in ipairs(commands) do
    local is_callback = type(autocmd.command) == "function"
    api.nvim_create_autocmd(autocmd.event, {
      group = group,
      pattern = autocmd.pattern,
      desc = autocmd.desc,
      callback = is_callback and autocmd.command or nil,
      command = not is_callback and autocmd.command or nil,
      once = autocmd.once,
      nested = autocmd.nested,
      buffer = autocmd.buffer,
    })
  end
end

augroup("AutoSyncPlugins", {
  {
    event = "BufWritePost",
    pattern = "plugins.lua",
    command = "source <afile> | PackerSync",
    desc = "Sync neovim plugins when plugins.lua is saved.",
  },
})

augroup("PlaceLastEdit", {
  {
    event = "BufReadPost",
    pattern = "*",
    command = function()
      if fn.line([['"]]) > 1 and fn.line([['"]]) <= fn.line("$") then
        cmd([[normal! g`"]])
      end
    end,
    desc = "Place to last edit.",
  },
})

augroup("SmartClose", {
  {
    event = "FileType",
    pattern = { "qf", "help", "man", "lspinfo", "startuptime", "tsplayground" },
    command = function()
      local opts = { noremap = true, silent = true }
      api.nvim_buf_set_keymap(0, "n", "q", ":close<CR>", opts)
    end,
    desc = "Close certain filetypes by pressing q.",
  },
  {
    event = "BufEnter",
    pattern = "*",
    nested = true,
    command = function()
      if #api.nvim_list_wins() == 1 and api.nvim_buf_get_name(0):match("NvimTree_") ~= nil then
        cmd("quit")
      end
    end,
    desc = "Close the tab when nvim-tree is the last window in the tab.",
  },
  {
    event = "BufEnter",
    pattern = "*",
    command = function()
      if fn.winnr("$") == 1 and bo.buftype == "quickfix" then
        api.nvim_buf_delete(0, { force = true })
      end
    end,
    desc = "Close quick fix window if the file containing it was closed.",
  },
  {
    event = "QuitPre",
    pattern = "*",
    nested = true,
    command = function()
      if bo.filetype ~= "qf" then
        cmd("silent! lclose")
      end
    end,
    desc = "automatically close corresponding loclist when quitting a window.",
  },
})

augroup("SetupTerminalMappings", {
  {
    event = { "TermOpen" },
    pattern = "term://*",
    command = function()
      if bo.filetype == "toggleterm" then
        local opts = { noremap = true, silent = true }
        api.nvim_buf_set_keymap(0, "t", "jj", [[<C-\><C-n>]], opts)
        api.nvim_buf_set_keymap(0, "t", "<Esc>", [[<C-\><C-n>]], opts)
        api.nvim_buf_set_keymap(0, "t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
        api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-w>hi]], opts)
        api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<C-\><C-n><C-w>ji]], opts)
        api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<C-\><C-n><C-w>ki]], opts)
        api.nvim_buf_set_keymap(0, "t", "<C-l>", [[<C-\><C-n><C-w>li]], opts)

        api.nvim_buf_set_keymap(0, "n", "<C-h>", [[<C-\><C-n><C-w>hi]], opts)
        api.nvim_buf_set_keymap(0, "n", "<C-j>", [[<C-\><C-n><C-w>ji]], opts)
        api.nvim_buf_set_keymap(0, "n", "<C-k>", [[<C-\><C-n><C-w>ki]], opts)
        api.nvim_buf_set_keymap(0, "n", "<C-l>", [[<C-\><C-n><C-w>li]], opts)
      end
    end,
    desc = "setup toggleterm keymap.",
  },
})
