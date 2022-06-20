local g = vim.g

g.copilot_filetypes = {
  ["*"] = true,
  gitcommit = false,
  NeogitCommitMessage = false,
}

g.copilot_no_tab_map = true

vim.api.nvim_set_keymap("i", "<C-j>", "copilot#Accept('<CR>')", { silent = true, expr = true })
