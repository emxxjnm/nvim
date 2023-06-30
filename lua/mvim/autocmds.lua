local U = require("mvim.utils")

-- U.augroup("AutoCursorLine", {
--   event = { "InsertLeave", "WinEnter" },
--   command = function()
--     local ok, cl = pcall(vim.api.nvim_win_get_var, 0, "auto-cursorline")
--     if ok and cl then
--       vim.wo.cursorline = true
--       vim.api.nvim_win_del_var(0, "auto-cursorline")
--     end
--   end,
--   desc = "Hide cursor line in inactive window",
-- }, {
--   event = { "InsertEnter", "WinLeave" },
--   command = function()
--     local cl = vim.wo.cursorline
--     if cl then
--       vim.api.nvim_win_set_var(0, "auto-cursorline", cl)
--       vim.wo.cursorline = false
--     end
--   end,
--   desc = "Show cursor line only in active window",
-- })

local ignore_buftype = { "quickfix", "nofile", "help", "terminal" }
local ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" }

U.augroup("PlaceLastLoc", {
  event = { "BufWinEnter", "FileType" },
  command = function()
    if vim.tbl_contains(ignore_buftype, vim.bo.buftype) then
      return
    end

    if vim.tbl_contains(ignore_filetype, vim.bo.filetype) then
      -- reset cursor to first line
      vim.cmd("normal! gg")
      return
    end

    -- If a line has already been specified on the command line, we are done e.g. nvim file +num
    if vim.fn.line(".") > 1 then
      return
    end

    local last_line = vim.fn.line([['"]])
    local buff_last_line = vim.fn.line("$")

    -- If the last line is set and the less than the last line in the buffer
    if last_line > 0 and last_line <= buff_last_line then
      local win_last_line = vim.fn.line("w$")
      local win_first_line = vim.fn.line("w0")
      -- Check if the last line of the buffer is the same as the win
      if win_last_line == buff_last_line then
        vim.cmd('normal! g`"') -- Set line to last line edited
      -- Try to center
      elseif buff_last_line - last_line > ((win_last_line - win_first_line) / 2) - 1 then
        vim.cmd('normal! g`"zz')
      else
        vim.cmd([[normal! G'"<c-e>]])
      end
    end
  end,
  desc = "Go to last loc when opening a buffer",
})

U.augroup("CloseWithQ", {
  event = "FileType",
  pattern = {
    "qf",
    "man",
    "help",
    "lspinfo",
    "startuptime",
    "checkhealth",
    "spectre_panel",
    "neotest-output",
    "neotest-attach",
    "neotest-summary",
  },
  command = function(args)
    vim.bo[args.buf].buflisted = false
    vim.keymap.set("n", "q", "<Cmd>close<CR>", { buffer = args.buf, silent = true })
  end,
  desc = "Close certain filetypes by pressing <q>",
})

U.augroup("CheckOutsideTime", {
  event = { "FocusGained", "TermClose", "TermLeave" },
  command = "checktime",
  desc = "Check if we need to reload the file when it changed",
})

U.augroup("TextYankHighlight", {
  event = { "TextYankPost" },
  command = function()
    vim.highlight.on_yank()
  end,
  desc = "Highlight on yank",
})
