local U = require("mvim.utils")

local cursorline_bt_exclude = { "terminal" }
local cursorline_ft_exclude = { "alpha", "toggleterm", "neo-tree-popup", "TelescopePrompt" }

-- Works better on non-transparent backgrounds
U.augroup("AutoCursorLine", {
  event = { "BufEnter", "InsertLeave" },
  command = function(args)
    vim.wo.cursorline = not vim.wo.previewwindow
      and not vim.tbl_contains(cursorline_bt_exclude, vim.bo[args.buf].buftype)
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

local last_place_bt_ignore = { "quickfix", "nofile", "help", "terminal" }
local last_place_ft_ignore = { "gitcommit", "gitrebase", "svn", "hgcommit" }

U.augroup("LastPlaceLoc", {
  event = { "BufWinEnter", "FileType" },
  command = function(args)
    if vim.tbl_contains(last_place_bt_ignore, vim.bo[args.buf].buftype) then
      return
    end

    if vim.tbl_contains(last_place_ft_ignore, vim.bo[args.buf].filetype) then
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
    "query",
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

if U.has("neo-tree.nvim") then
  U.augroup("RefreshGitStatus", {
    pattern = "*.lazygit",
    event = "TermClose",
    command = function()
      if package.loaded["neo-tree.sources.git_status"] then
        require("neo-tree.sources.git_status").refresh()
      end
    end,
    desc = "Refresh Neo-Tree git when closing lazygit",
  })
end
