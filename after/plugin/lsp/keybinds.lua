local utils = require("mvim.plugins.lsp.utils")
local helper = require("mvim.plugins.lsp.helper")

local lsp, keymap, diagnostic = vim.lsp, vim.keymap.set, vim.diagnostic

---setup the lsp keymap
---@param bufnr number
local function setup_keymaps(bufnr)
  local function with_desc(desc)
    return { buffer = bufnr, silent = true, desc = desc }
  end

  -- Code actions
  keymap("n", ",f", utils.format, with_desc("LSP: Format"))
  keymap("n", "<leader>rn", lsp.buf.rename, with_desc("LSP: Rename"))
  keymap({ "n", "x" }, "<leader>ca", lsp.buf.code_action, with_desc("LSP: Code action"))

  -- Movement
  keymap("n", "gD", lsp.buf.declaration, with_desc("LSP: Declaration"))
  keymap("n", "gd", helper.definitions, with_desc("LSP: Definitions"))
  keymap("n", "gr", helper.references, with_desc("LSP: References"))
  keymap("n", "gbr", helper.buffer_references, with_desc("LSP: Buffer references"))
  keymap("n", "gi", helper.implementations, with_desc("LSP: Implementations"))

  keymap("n", "[d", diagnostic.goto_prev, with_desc("LSP: Move to the prev diagnostic"))
  keymap("n", "]d", diagnostic.goto_next, with_desc("LSP: Move to the next diagnostic"))

  -- Docs
  keymap("n", "K", lsp.buf.hover, with_desc("LSP: Hover"))
  keymap({ "n", "i" }, "<C-k>", lsp.buf.signature_help, with_desc("LSP: Signature help"))
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    setup_keymaps(bufnr)
  end,
})
