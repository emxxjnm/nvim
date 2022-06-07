local g = vim.g
local keymap = vim.api.nvim_set_keymap

g.copilot_filetypes = {
  ["*"] = true,
  gitcommit = false,
  NeogitCommitMessage = false,
}

g.copilot_no_tab_map = true

keymap("i", "<C-j>", "copilot#Accept('<CR>')", { silent = true, expr = true })
