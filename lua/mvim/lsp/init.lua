local M = {}

local function lsp_buffer_keymaps(bufnr)
  local opts = { noremap = true, silent = true }

  local mappings = {
    normal_mode = "n",
    insert_mode = "i",
    visual_mode = "v",
  }

  local keymappings = {
    normal_mode = {
      ["K"] = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Show hover" },
      ["gd"] = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Goto Definition" },
      ["gD"] = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "Goto Daclaration" },
      ["gr"] = { "<cmd>lua vim.lsp.buf.references()<cr>", "Goto References" },
      ["gi"] = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "Goto Implementation" },
      ["<C-k"] = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Show Signature Help" },
      ["<leader>rn"] = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
      ["<leader>ca"] = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
      [",f"] = { "<cmd>lua vim.lsp.buf.formatting()<cr>", "Formatting" },
      ["<leader>rf"] = { "<cmd>lua vim.lsp.buf.range_formatting()<cr>", "Range Formatting" },
    },
    insert_mode = {},
    visual_mode = {},
  }

  for mode_name, mode_char in pairs(mappings) do
    for key, remap in pairs(keymappings[mode_name]) do
      vim.api.nvim_buf_set_keymap(bufnr, mode_char, key, remap[1], opts)
    end
  end
end

function M.mvim_on_attach(_, bufnr)
  -- keymap
  lsp_buffer_keymaps(bufnr)
end

function M.mvim_on_init() end

function M.mvim_on_exit() end

function M.mvim_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  }

  -- cmp-nvim
  local status_ok, cmp_nvim_lsp = pcall(require, "cmp-nvim-lsp")
  if status_ok then
    capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
  end

  return capabilities
end

-- options
function M.get_opts()
  return {
    on_attach = M.mvim_on_attach,
    on_init = M.mvim_on_init,
    on_exit = M.mvim_on_exit,
    capabilities = M.mvim_capabilities(),
  }
end

function M.setup()
  local status_ok, _ = pcall(require, "lspconfig")
  if not status_ok then
    return
  end

  -- setup handlers
  require("mvim.lsp.handlers").setup()

  -- setup installer
  require("nvim-lsp-installer").setup({
    ui = {
      border = "rounded",
    },
  })

  -- setup null-ls
  require("mvim.lsp.extension").setup()

  -- local formatters = require("mvim.lsp.extension.formatters")
  -- local linter = require("mvim.lsp.extension.linters")
  -- formatters.setup({
  --   {
  --     command = "markdownlint",
  --     filetypes = { "markdown" },
  --   },
  --   -- {
  --   --   command = "stylua",
  --   --   filetypes = { "lua" },
  --   -- },
  -- })
  -- linter.setup({
  --   {
  --     command = "markdownlint",
  --     filetypes = { "markdown" },
  --   },
  -- })
end

return M
