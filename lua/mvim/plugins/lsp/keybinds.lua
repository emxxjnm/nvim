local M = {}

local config = require("telescope.config").values
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local builtin = require("telescope.builtin")
local make_entry = require("telescope.make_entry")

---@type PluginLspKeys
M._keys = nil

---@return (LazyKeys|{has?:string})[]
function M.get()
  local format = require("mvim.plugins.lsp.format").format

  ---@class PluginLspKeys
  M._keys = M._keys
    or {
      { "gd", "<cmd>Telescope lsp_definitions<cr>", desc = "Goto Definition" },
      { "gr", "<cmd>Telescope lsp_references<cr>", desc = "References" },
      { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
      { "gi", "<cmd>Telescope lsp_implementations<cr>", desc = "Goto Implementation" },
      { "gt", "<cmd>Telescope lsp_type_definitions<cr>", desc = "Goto Type Definition" },

      { "K", vim.lsp.buf.hover, desc = "Hover" },
      { "gK", vim.lsp.buf.signature_help, desc = "Signature Help", has = "signatureHelp" },
      {
        "<C-k>",
        vim.lsp.buf.signature_help,
        mode = "i",
        desc = "Signature Help",
        has = "signatureHelp",
      },

      { "[d", vim.diagnostic.goto_prev, desc = "Prev Diagnostic" },
      { "]d", vim.diagnostic.goto_next, desc = "Next Diagnostic" },

      { "<leader>cf", format, desc = "Format Document", has = "documentFormatting" },
      { "<leader>cf", format, desc = "Format Range", mode = "v", has = "documentRangeFormatting" },
      { "<leader>cr", vim.lsp.buf.rename, expr = true, desc = "Rename", has = "rename" },
      {
        "<leader>ca",
        vim.lsp.buf.code_action,
        desc = "Code Action",
        mode = { "n", "v" },
        has = "codeAction",
      },

      { "<leader>cl", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
    }
  return M._keys
end

function M.on_attach(client, buffer)
  local Keys = require("lazy.core.handler.keys")
  local keymaps = {} ---@type table<string,LazyKeys|{has?:string}>

  for _, value in ipairs(M.get()) do
    local keys = Keys.parse(value)
    if keys[2] == vim.NIL or keys[2] == false then
      keymaps[keys.id] = nil
    else
      keymaps[keys.id] = keys
    end
  end

  for _, keys in pairs(keymaps) do
    if not keys.has or client.server_capabilities[keys.has .. "Provider"] then
      local opts = Keys.opts(keys)
      opts.has = nil
      opts.silent = true
      opts.buffer = buffer
      vim.keymap.set(keys.mode or "n", keys[1], keys[2], opts)
    end
  end
end

function M.buffer_references(opts)
  opts = opts or {}
  local params = vim.lsp.util.make_position_params(opts.winnr, "utf-8")
  params.context = { includeDeclaration = true }

  vim.lsp.buf_request(opts.bufnr, "textDocument/references", params, function(err, result, ctx, _)
    if err then
      vim.api.nvim_err_writeln("Error when finding references: " .. err.message)
      return
    end

    local locations = {}
    if result then
      local buf_uri = vim.uri_from_bufnr(0)
      local filtered_result = vim.tbl_filter(function(location)
        return (location.uri or location.targetUri) == buf_uri
      end, result)

      if filtered_result then
        locations = vim.lsp.util.locations_to_items(
          filtered_result,
          vim.lsp.get_client_by_id(ctx.client_id).offset_encoding
        )
      end
    end

    if vim.tbl_isempty(locations) then
      return
    end

    pickers
      .new(opts, {
        prompt_title = "LSP References(buffer)",
        finder = finders.new_table({
          results = locations,
          entry_maker = opts.entry_maker or make_entry.gen_from_quickfix(opts),
        }),
        previewer = config.qflist_previewer(opts),
        sorter = config.generic_sorter(opts),
      })
      :find()
  end)
end

function M.document_symbols()
  local symbols = {
    "All",
    "Variable",
    "Function",
    "Constant",
    "Class",
    "Property",
    "Method",
    "Enum",
    "Interface",
    "Boolean",
    "Number",
    "String",
    "Array",
    "Constructor",
  }

  vim.ui.select(symbols, { prompt = "Select which symbol" }, function(item)
    if item == "All" then
      builtin.lsp_document_symbols()
    else
      builtin.lsp_document_symbols({ symbols = item })
    end
  end)
end

function M.workspace_symbols()
  vim.ui.input({ prompt = "Workspace symbols query:" }, function(query)
    if query ~= "" then
      builtin.lsp_workspace_symbols({ query = query })
    else
      builtin.lsp_workspace_symbols()
    end
  end)
end

return M
