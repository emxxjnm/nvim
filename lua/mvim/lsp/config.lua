local M = {}

local utils = require("mvim.lsp.utils")
local helper = require("mvim.lsp.helper")

local fn = vim.fn
local api = vim.api
local lsp = vim.lsp
local keymap = vim.keymap
local diagnostic = vim.diagnostic
local fmt = string.format

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

local function formatter_filter(client)
  local exclude = ({
    lua = { "sumneko_lua" },
  })[vim.bo.filetype]

  if not exclude then
    return true
  end
  return not vim.tbl_contains(exclude, client.name)
end

---@param opts table<string, any>
local function format(opts)
  opts = opts or {}
  lsp.buf.format({
    bufnr = opts.bufnr,
    async = opts.async,
    filter = formatter_filter,
  })
end

local function get_augroup(bufnr)
  assert(bufnr, "A bufnr is required to create an lsp augroup")
  return fmt("LspCommands_%d", bufnr)
end

---Add lsp autocmd
--@param client table<string, any>
--@param bufnr number buffer id
local function setup_autocmd(client, bufnr)
  if not client then
    local msg = fmt("Unable to setup LSP autocmd, client for %d is missing", bufnr)
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
        if not vim.g.formatting_disabled and not vim.b.formatting_disabled then
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
      command = function(args)
        if api.nvim_buf_is_valid(args.buf) then
          lsp.codelens.refresh()
        end
      end,
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
  local function with_desc(desc)
    return { buffer = bufnr, silent = true, desc = desc }
  end

  -- Code actions
  keymap.set("n", ",f", format, with_desc("LSP: Format"))
  keymap.set("n", "<leader>rn", lsp.buf.rename, with_desc("LSP: Rename"))
  keymap.set({ "n", "x" }, "<leader>ca", lsp.buf.code_action, with_desc("LSP: Code action"))

  -- Movement
  keymap.set("n", "gD", lsp.buf.declaration, with_desc("LSP: Declaration"))
  keymap.set("n", "gd", helper.definitions, with_desc("LSP: Definitions"))
  keymap.set("n", "gr", helper.references, with_desc("LSP: References"))
  keymap.set("n", "gbr", helper.buffer_references, with_desc("LSP: Buffer references"))
  keymap.set("n", "gi", helper.implementations, with_desc("LSP: Implementations"))

  keymap.set("n", "[d", diagnostic.goto_prev, with_desc("LSP: Go to prev diagnostic"))
  keymap.set("n", "]d", diagnostic.goto_next, with_desc("LSP: Go to next diagnostic"))

  -- Docs
  keymap.set("n", "K", lsp.buf.hover, with_desc("LSP: Hover"))
  keymap.set({ "n", "i" }, "<C-k>", lsp.buf.signature_help, with_desc("LSP: Signature help"))
end

---@param bufnr number buffer id
local function setup_options(bufnr)
  api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
  api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr(#{timeout_ms:500})")
end

---Add buffer local mappings, autocommands etc for attaching servers
--@param client table the lsp client
--@param bufnr number buffer id
function M.common_on_attach(client, bufnr)
  -- if client.config.flags then
  --   client.config.flags.allow_incremental_sync = true
  -- end

  setup_keymaps(bufnr)
  setup_autocmd(client, bufnr)
  setup_options(bufnr)
end

---This function allows reading a per project `settings.josn` file
---in the `.vim` directory of the project
--@param client table<string, any> lsp client
--@return boolean
function M.common_on_init(client)
  local settings = client.workspace_folders[1].name .. "/.vim/settings.json"
  if fn.filereadable(settings) == 0 then
    return true
  end
  local ok, json = pcall(fn.readfile, settings)
  if not ok then
    return true
  end
  local overrides = vim.json.decode(table.concat(json, "\n"))
  for name, config in pairs(overrides) do
    if name == client.name then
      client.config = vim.tbl_deep_extend("force", client.config, config)
      client.notify("workspace/didChangeConfiguration")
      vim.schedule(function()
        local path = fn.fnamemodify(settings, ":~:.")
        local msg = fmt("loaded local settings for %s from %s", client.name, path)
        vim.notify_once(msg, "info", { title = "LSP Settings" })
      end)
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
