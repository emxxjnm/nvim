local utils = require("mvim.lsp.utils")
local helper = require("mvim.lsp.helper")

local fn = vim.fn
local lsp = vim.lsp
local api = vim.api
local fmt = string.format
local keymap = vim.keymap
local diagnostic = vim.diagnostic

local icons = {
  error = "",
  warn = "",
  info = "",
  hint = "",
}

local function highlight_references()
  local ok, ts_utils = mo.require("nvim-treesitter.ts_utils")
  if not ok then
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
    typescript = { "tsserver" },
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
    return vim.notify(msg, vim.log.levels.ERROR, { title = "LSP Setup" })
  end

  local group = get_augroup(bufnr)

  local cmds = {}

  table.insert(cmds, {
    event = "CursorHold",
    buffer = bufnr,
    command = function(args)
      diagnostic.open_float(args.buf, { scope = "cursor", focus = false })
    end,
    desc = "LSP: Show Diagnostics",
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
      desc = "LSP: Format on save",
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
local function on_attach(client, bufnr)
  setup_keymaps(bufnr)
  setup_autocmd(client, bufnr)
  setup_options(bufnr)

  local navic_ok, navic = pcall(require, "nvim-navic")
  if navic_ok and client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end
end

mo.augroup("LspSetupCommands", {
  {
    event = "LspAttach",
    desc = "setup the languages server autocommands",
    command = function(args)
      local bufnr = args.buf
      -- if the buffer is invalid we should not try and attach to it
      if not api.nvim_buf_is_valid(bufnr) or not args.data then
        return
      end
      local client = lsp.get_client_by_id(args.data.client_id)
      on_attach(client, bufnr)
    end,
  },
  {
    event = "LspDetach",
    desc = "clean up after detached LSP",
    command = function(args)
      -- only clear autocommands if there are no other client attached to the buffer
      if next(lsp.get_active_clients({ bufnr = args.buf })) then
        return
      end

      pcall(api.nvim_clear_autocmds, { group = get_augroup(args.buf), buffer = args.buf })
    end,
  },
})

local ns = api.nvim_create_namespace("severe-diagnostics")

--- Restricts nvim's diagnostic signs to only the single most severe one per line
--- @see `:help vim.diagnostic`
local function max_diagnostic(callback)
  return function(_, bufnr, _, opts)
    -- Get all diagnostics from the whole buffer rather than just the
    -- diagnostics passed to the handler
    local diagnostics = vim.diagnostic.get(bufnr)
    -- Find the "worst" diagnostic per line
    local max_severity_per_line = {}
    for _, d in pairs(diagnostics) do
      local m = max_severity_per_line[d.lnum]
      if not m or d.severity < m.severity then
        max_severity_per_line[d.lnum] = d
      end
    end
    -- Pass the filtered diagnostics (with our custom namespace) to the original handler
    callback(ns, bufnr, vim.tbl_values(max_severity_per_line), opts)
  end
end

local virt_text_handler = diagnostic.handlers.virtual_text or {}
diagnostic.handlers.virtual_text = vim.tbl_extend("force", virt_text_handler, {
  show = max_diagnostic(virt_text_handler.show),
  hide = function(_, bufnr)
    virt_text_handler.hide(ns, bufnr)
  end,
})

-- Diagnostic configuration
diagnostic.config({
  signs = true,
  underline = true,
  severity_sort = true,
  update_in_insert = false,
  virtual_text = false,
  float = {
    header = "",
    border = mo.style.border.current,
    source = true,
    focusable = false,
    prefix = function(d, i)
      local level = diagnostic.severity[d.severity]
      local prefix = fmt("%d. %s ", i, icons[level:lower()])
      return prefix, "Diagnostic" .. level
    end,
  },
})

fn.sign_define({
  {
    text = icons.hint,
    name = "DiagnosticSignHint",
    numhl = "DiagnosticSignHint",
    texthl = "DiagnosticSignHint",
  },
  {
    text = icons.info,
    name = "DiagnosticSignInfo",
    numhl = "DiagnosticSignInfo",
    texthl = "DiagnosticSignInfo",
  },
  {
    text = icons.warn,
    name = "DiagnosticSignWarn",
    numhl = "DiagnosticSignWarn",
    texthl = "DiagnosticSignWarn",
  },
  {
    text = icons.error,
    name = "DiagnosticSignError",
    numhl = "DiagnosticSignError",
    texthl = "DiagnosticSignError",
  },
})

lsp.handlers["textDocument/hover"] = lsp.with(lsp.handlers.hover, {
  border = mo.style.border.current,
})
