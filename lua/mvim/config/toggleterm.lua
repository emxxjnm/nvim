local M = {}

function M.setup()
  require("toggleterm").setup({
    open_mapping = [[<c-\>]],
    shade_terminals = false,
    shading_factor = 1,
    start_in_insert = true,
    insert_mappings = false,
    persist_size = false,
    direction = "horizontal",
    autochdir = true,
    highlights = {
      NormalFloat = {
        link = "NormalFloat",
      },
      FloatBorder = {
        link = "FloatBorder",
      },
    },
    size = function(term)
      if term.direction == "horizontal" then
        return math.floor(vim.o.lines * 0.4)
      elseif term.direction == "vertical" then
        return math.floor(vim.o.columns * 0.4)
      end
    end,
    float_opts = {
      border = mo.style.border.current,
      width = function()
        return math.floor(vim.o.columns * 0.9)
      end,
      height = function()
        return math.floor(vim.o.lines * 0.9)
      end,
    },
  })
end

return M
