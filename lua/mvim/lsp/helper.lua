local config = require("telescope.config").values
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local builtin = require("telescope.builtin")
local make_entry = require("telescope.make_entry")

local M = {}

local lsp = vim.lsp

function M.definitions()
  builtin.lsp_definitions()
end

function M.implementations()
  builtin.lsp_implementations()
end

function M.workspace_diagnostics()
  builtin.diagnostics()
end

function M.document_diagnostics()
  builtin.diagnostics({ bufnr = 0 })
end

function M.references()
  builtin.lsp_references()
end

function M.buffer_references(opts)
  opts = opts or {}
  local params = lsp.util.make_position_params(opts.winnr, "utf-8")
  params.context = { includeDeclaration = true }

  lsp.buf_request(opts.bufnr, "textDocument/references", params, function(err, result, ctx, _)
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
        locations = lsp.util.locations_to_items(
          filtered_result,
          lsp.get_client_by_id(ctx.client_id).offset_encoding
        )
      end
    end

    if vim.tbl_isempty(locations) then
      return
    end

    pickers.new(opts, {
      prompt_title = "LSP References(buffer)",
      finder = finders.new_table({
        results = locations,
        entry_maker = opts.entry_maker or make_entry.gen_from_quickfix(opts),
      }),
      previewer = config.qflist_previewer(opts),
      sorter = config.generic_sorter(opts),
    }):find()
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
