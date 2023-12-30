local U = require("mvim.util")

local cursorline_ft_exclude = { "dashboard" }

-- Works better on non-transparent backgrounds
U.augroup("AutoCursorLine", {
  event = { "BufEnter", "InsertLeave" },
  command = function(args)
    vim.wo.cursorline = not vim.wo.previewwindow
      and vim.wo.winhighlight == ""
      and vim.bo[args.buf].filetype ~= ""
      and not vim.tbl_contains(cursorline_ft_exclude, vim.bo[args.buf].filetype)
  end,
  desc = "Hide cursor line in inactive window",
}, {
  event = { "BufLeave", "InsertEnter" },
  command = function()
    vim.wo.cursorline = false
  end,
  desc = "Show cursor line only in active window",
})

U.augroup("LastPlaceLoc", {
  event = "BufReadPost",
  command = function(args)
    local exclude = { "gitcommit" }
    local buf = args.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazy_last_loc then
      return
    end
    vim.b[buf].lazy_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
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
    "query",
    "lspinfo",
    "startuptime",
    "checkhealth",
    "neotest-output",
    "neotest-attach",
    "neotest-summary",
    "neotest-output-panel",
  },
  command = function(args)
    vim.bo[args.buf].buflisted = false
    vim.keymap.set("n", "q", "<Cmd>close<CR>", { buffer = args.buf, silent = true })
  end,
  desc = "Close certain filetypes by pressing <q>",
})

U.augroup("TextYankHighlight", {
  event = { "TextYankPost" },
  command = function()
    vim.highlight.on_yank()
  end,
  desc = "Highlight on yank",
})
