local utils = require("mvim.lsp.utils")
local helper = require("mvim.lsp.helper")

local M = {}

local api = vim.api
local lsp = vim.lsp
local keymap = vim.keymap
local diagnostic = vim.diagnostic

local function highlight_references()
  local ts_utils_ok, ts_utils = pcall(require, "nvim-treesitter.ts_utils")
  if not ts_utils_ok then
    return
  end

  local node = ts_utils.get_node_at_cursor()
  while node ~= nil do
    local node_type = node:type()
    if
      node_type == "string"
      or node_type == "string_fragment"
      or node_type == "template_string"
      or node_type == "documnet"
    then
      return
    end
    node = node:parent()
  end
  lsp.buf.document_highlight()
end

---@param bufnr number
local function setup_document_highlight(bufnr)
  local group = api.nvim_create_augroup("lsp_document_highlight", {})
  api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    buffer = bufnr,
    group = group,
    callback = highlight_references,
    -- callback = utils.fn(lsp.buf.document_highlight),
  })
  api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    buffer = bufnr,
    group = group,
    callback = utils.fn(lsp.buf.clear_references),
  })
  api.nvim_create_autocmd({ "CursorHold" }, {
    buffer = bufnr,
    group = group,
    -- callback = diagnostic_popup,
    callback = utils.fn(diagnostic.open_float),
  })
end

---@param bufnr number
local function setup_codelens_refresh(bufnr)
  local group = api.nvim_create_augroup("lsp_document_codelens", {})
  api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "BufWritePost" }, {
    buffer = bufnr,
    group = group,
    callback = utils.fn(lsp.codelens.refresh),
  })
end

---setup the lsp keymap
--@param bufnr number
local function buf_set_keymaps(bufnr)
  local function set_keymap(mode, lhs, rhs)
    keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true })
  end

  -- Code actions
  set_keymap("n", ",f", lsp.buf.formatting)
  set_keymap("n", ",rf", lsp.buf.range_formatting)
  set_keymap("n", "<leader>rn", lsp.buf.rename)
  set_keymap("n", "<leader>ca", lsp.buf.code_action)

  -- Movement
  set_keymap("n", "gD", lsp.buf.declaration)
  set_keymap("n", "gd", helper.definitions)
  set_keymap("n", "gr", helper.references)
  set_keymap("n", "gbr", helper.buffer_references)
  set_keymap("n", "gi", helper.implementations)

  -- Docs
  set_keymap("n", "K", lsp.buf.hover)
  set_keymap("n", "<C-k>", lsp.buf.signature_help)
  set_keymap("i", "<C-k>", lsp.buf.signature_help)

  -- set_keymap("n", "<C-,>", diagnostic.open_float)
  -- set_keymap("i", "<C-,>", diagnostic.open_float)

  -- set_keymap("n", "<C-a>", helper.document_diagnostics)
  -- set_keymap("n", "<C-a>", helper.workspace_diagnostics)
end

function M.mvim_on_attach(client, bufnr)
  api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  buf_set_keymaps(bufnr)

  if client.config.flags then
    client.config.flags.allow_incremental_sync = true
  end

  if client.supports_method("textDocument/documentHighlight") then
    setup_document_highlight(bufnr)
  end

  if client.supports_method("textDocument/codeLens") then
    setup_codelens_refresh(bufnr)
    vim.schedule(lsp.codelens.refresh)
  end
end

function M.mvim_on_init() end

function M.mvim_on_exit() end

function M.mvim_capabilities()
  local capabilities = lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  }

  local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
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
  local ok, util = pcall(require, "lspconfig.util")
  if not ok then
    return
  end

  util.on_setup = util.add_hook_after(util.on_setup, function(config)
    if config.on_attach then
      config.on_attach = util.add_hook_after(config.on_attach, M.mvim_on_attach)
    else
      config.on_attach = M.mvim_on_attach
    end
    config.capabilities = M.mvim_capabilities()
  end)

  -- setup handlers
  require("mvim.lsp.handlers").setup()
end

return M
