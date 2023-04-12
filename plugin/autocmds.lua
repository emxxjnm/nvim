local U = require("mvim.utils")

if not mo.styles.transparent then
  U.augroup("AutoCursorLine", {
    event = { "InsertLeave", "WinEnter" },
    command = function()
      local ok, cl = pcall(vim.api.nvim_win_get_var, 0, "auto-cursorline")
      if ok and cl then
        vim.wo.cursorline = true
        vim.api.nvim_win_del_var(0, "auto-cursorline")
      end
    end,
    desc = "Hide cursor line in inactive window",
  }, {
    event = { "InsertEnter", "WinLeave" },
    command = function()
      local cl = vim.wo.cursorline
      if cl then
        vim.api.nvim_win_set_var(0, "auto-cursorline", cl)
        vim.wo.cursorline = false
      end
    end,
    desc = "Show cursor line only in active window",
  })
end

U.augroup("PlaceLastLoc", {
  event = "BufReadPost",
  command = function()
    local excluded = { "gitcommit", "dap-repl" }
    if vim.tbl_contains(excluded, vim.bo.filetype) and vim.fn.win_gettype() ~= "popup" then
      local mark = vim.api.nvim_buf_get_mark(0, '"')
      local line_nr = mark[1]
      local line_count = vim.api.nvim_buf_line_count(0)

      if line_nr > 0 and line_nr <= line_count then
        vim.api.nvim_win_set_cursor(0, mark)
      end
    end
  end,
  desc = "Go to last loc when opening a buffer",
})

U.augroup("SmartClose", {
  event = "FileType",
  pattern = {
    "qf",
    "help",
    "man",
    "lspinfo",
    "startuptime",
    "spectre_panel",
    "neotest-output",
    "neotest-attach",
    "neotest-summary",
  },
  command = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<Cmd>close<CR>", { noremap = true, silent = true })
  end,
  desc = "Close certain filetypes by pressing <q>",
})

U.augroup("CheckOutsideTime", {
  event = { "WinEnter", "BufWinEnter", "BufWinLeave", "BufRead", "BufEnter", "FocusGained" },
  command = "checktime",
  desc = "Check if we need to reload the file when it changed",
})

U.augroup("TextYankHighlight", {
  event = { "TextYankPost" },
  command = function()
    vim.highlight.on_yank({
      timeout = 500,
      on_visual = false,
      higroup = "Visual",
    })
  end,
  desc = "Highlight on yank",
})
