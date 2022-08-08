local M = {}

local utils = require("mvim.lsp.utils")
local helper = require("mvim.lsp.helper")

local fn = vim.fn
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
  api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "CursorHold", "BufWritePost" }, {
    buffer = bufnr,
    group = group,
    callback = utils.fn(lsp.codelens.refresh),
  })
end

local function formatter_filter(client)
  local exclude = ({
    lua = { "sumneko_lua" },
  })[vim.bo.filetype]

  if not exclude then
    return true
  end
  return not vim.tbl_contains(exclude, client.name)
end

local function format(opts)
  opts = opts or {}
  vim.lsp.buf.format({
    bufnr = opts.bufnr,
    async = opts.async,
    filter = formatter_filter,
  })
end

--@param bufnr number
local function setup_code_format(bufnr)
  local group = api.nvim_create_augroup("lsp_code_format", {})
  api.nvim_create_autocmd({ "BufWritePre" }, {
    buffer = bufnr,
    group = group,
    callback = function(args)
      if not vim.g.formatting_disabled then
        format({ bufnr = args.buf, async = false })
      end
    end,
    desc = "format current buffer on save.",
  })
end

local function get_augroup(bufnr)
  assert(bufnr, "A bufnr is required to create an lsp augroup")
  return string.format("LspCommands_%d", bufnr)
end

---Add lsp autocmd
--@param client table<string, any>
--@param bufnr number buffer id
local function setup_autocmd(client, bufnr)
  if not client then
    local msg = string.format("Unable to setup LSP autocmd, client for %d is missing", bufnr)
    return vim.notify(msg, "error", { title = "LSP Setup" })
  end

  local group = get_augroup(bufnr)
  -- Clear pre-existing buffer autocommands
  pcall(api.nvim_clear_autocmds, { group = group, buffer = bufnr })
  -- mo.clear_augroup(group)

  local cmds = {}

  table.insert(cmds, {
    event = "CursorHold",
    buffer = bufnr,
    command = utils.fn(diagnostic.open_float),
    desc = "Show Diagnostics",
  })
  if client.server_capabilities.documentFormattingProvider then
    table.insert(cmds, {
      event = "BufWritePre",
      buffer = bufnr,
      command = function(args)
        if not vim.g.formatting_disabled then
          format({ bufnr = args.buf, async = false })
        end
      end,
      desc = "Format current buffer on save",
    })
  end

  if client.server_capabilities.codeLensProvider then
    table.insert(cmds, {
      event = { "BufEnter", "InsertLeave", "CursorHold", "BufWritePost" },
      buffer = bufnr,
      command = utils.fn(lsp.codelens.refresh),
      desc = "Refresh code lens",
    })
  end

  if client.server_capabilities.documentHighlightProvider then
    table.insert(cmds, {
      event = { "CursorHold", "CursorHoldI" },
      buffer = bufnr,
      command = highlight_references,
      desc = "Document Highlight",
    })
    table.insert(cmds, {
      event = "CursorMoved",
      buffer = bufnr,
      command = utils.fn(lsp.buf.clear_references),
      desc = "Document Highlight clear",
    })
  end

  mo.augroup(group, cmds)
end

---setup the lsp keymap
--@param bufnr number
local function setup_keymaps(bufnr)
  local function set_keymap(mode, lhs, rhs)
    keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true })
  end

  -- Code actions
  set_keymap("n", ",f", format)
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
end

---Add buffer local mappings, autocommands etc for attaching servers
--@param client table the lsp client
--@param bufnr number buffer id
function M.common_on_attach(client, bufnr)
  api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  setup_keymaps(bufnr)

  setup_autocmd(client, bufnr)

  if client.config.flags then
    client.config.flags.allow_incremental_sync = true
  end

  -- if client.server_capabilities.documentHighlightProvider then
  --   setup_document_highlight(bufnr)
  -- end
  --
  -- if client.server_capabilities.codeLensProvider then
  --   setup_codelens_refresh(bufnr)
  --   vim.schedule(lsp.codelens.refresh)
  -- end
  --
  -- if client.server_capabilities.documentFormattingProvider then
  --   setup_code_format(bufnr)
  -- end

  if client.server_capabilities.documentFormattingProvider then
    -- vim.bo[bufnr].formatexpr = "v:lua.vim.lsp.formatexpr()"
    api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr(#{timeout_ms:500})")
  end
end

---This function allows reading a per project `settings.josn` file
---in the `.vim` directory of the project
--@param client table<string, any> lsp client
--@return boolean
function M.common_on_init(client)
  local path = client.workspace_folders[1].name
  local config_path = path .. "/.vim/settings.json"
  if fn.filereadable(config_path) == 0 then
    return true
  end
  local ok, json = pcall(fn.readfile, config_path)
  if not ok then
    return true
  end
  local overrides = vim.json.decode(table.concat(json, "\n"))
  for name, config in pairs(overrides) do
    if name == client.name then
      local original = client.config
      client.config = vim.tbl_deep_extend("force", original, config)
      client.notify("workspace/didChangeConfiguration")
    end
  end
  return true
end

function M.common_on_exit() end

function M.common_capabilities()
  local capabilities = lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { "documentation", "detail", "additionalTextEdits" },
  }

  local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if status_ok then
    capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
  end

  return capabilities
end

---@return table
function M.get_common_opts()
  return {
    on_attach = M.common_on_attach,
    on_init = M.common_on_init,
    on_exit = M.common_on_exit,
    capabilities = M.common_capabilities(),
  }
end

return M
