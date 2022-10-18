local M = {}

function M.setup()
  local ufo = require("ufo")
  local strwidth = vim.api.nvim_strwidth

  local function handler(virt_text, lnum, end_lnum, width, truncate, ctx)
    local result = {}
    local suffix = ("%s (%d)"):format(mo.style.icons.misc.ellipsis, end_lnum - lnum)
    local cur_width = 0
    local suffix_width = strwidth(ctx.text)
    local target_width = width - suffix_width

    for _, chunk in ipairs(virt_text) do
      local chunk_text = chunk[1]
      local chunk_width = strwidth(chunk_text)
      if target_width > cur_width + chunk_width then
        table.insert(result, chunk)
      else
        chunk_text = truncate(chunk_text, target_width - cur_width)
        local hl_group = chunk[2]
        table.insert(result, { chunk_text, hl_group })
        chunk_width = strwidth(chunk_text)
        if cur_width + chunk_width < target_width then
          suffix = suffix .. (" "):rep(target_width - cur_width - chunk_width)
        end
        break
      end
      cur_width = cur_width + chunk_width
    end

    table.insert(result, { suffix, "UfoFoldedEllipsis" })
    return result
  end

  local ft_map = {}

  ufo.setup({
    open_fold_hl_timeout = 0,
    fold_virt_text_handler = handler,
    enable_get_fold_virt_text = true,
    preview = {
      win_config = {
        winblend = 0,
        border = mo.style.border.current,
        winhighlight = "Normal:Folded",
      },
    },
    provider_selector = function(_, filetype)
      return ft_map[filetype] or { "treesitter", "indent" }
    end,
  })

  vim.keymap.set("n", "zR", ufo.openAllFolds, {
    desc = "Open all folds",
  })
  vim.keymap.set("n", "zM", ufo.closeAllFolds, {
    desc = "Close all folds",
  })
  vim.keymap.set("n", "zP", ufo.peekFoldedLinesUnderCursor, {
    desc = "Preview fold",
  })
end

return M
