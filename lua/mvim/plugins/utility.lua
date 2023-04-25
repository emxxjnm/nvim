local M = {
  -- library used by other plugins
  { "nvim-lua/plenary.nvim", lazy = true },

  -- icons
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- ui components
  { "MunifTanjim/nui.nvim", lazy = true },

  -- undotree
  { "mbbill/undotree", event = "VeryLazy" },

  {
    "kevinhwang91/nvim-ufo",
    event = "BufReadPost",
    dependencies = { "kevinhwang91/promise-async" },
    keys = {
      {
        "zR",
        function()
          require("ufo").openAllFolds()
        end,
        desc = "Open all folds",
      },
      {
        "zM",
        function()
          require("ufo").closeAllFolds()
        end,
        desc = "Close all folds",
      },
      {
        "zP",
        function()
          require("ufo").peekFoldedLinesUnderCursor()
        end,
        desc = "Preview fold",
      },
    },
    opts = {
      open_fold_hl_timeout = 0,
      enable_get_fold_virt_text = true,
      preview = {
        win_config = {
          winblend = 0,
          border = mo.styles.border,
          winhighlight = "Normal:Folded",
        },
      },
      fold_virt_text_handler = function(virt_text, lnum, end_lnum, width, truncate, ctx)
        local result, cur_width, padding = {}, 0, ""
        local suffix = (" ---[%d]--- "):format(end_lnum - lnum)
        local suffix_width = vim.api.nvim_strwidth(ctx.text)
        local target_width = width - suffix_width

        for _, chunk in ipairs(virt_text) do
          local chunk_text = chunk[1]
          local chunk_width = vim.api.nvim_strwidth(chunk_text)
          if target_width > cur_width + chunk_width then
            table.insert(result, chunk)
          else
            chunk_text = truncate(chunk_text, target_width - cur_width)
            local hl_group = chunk[2]
            table.insert(result, { chunk_text, hl_group })
            chunk_width = vim.api.nvim_strwidth(chunk_text)
            if cur_width + chunk_width < target_width then
              padding = padding .. (" "):rep(target_width - cur_width - chunk_width)
            end
            break
          end
          cur_width = cur_width + chunk_width
        end

        local end_text = ctx.get_fold_virt_text(end_lnum)
        -- reformat the end text to trim excess whitespace from
        -- indentation usually the first item is indentation
        if end_text[1] and end_text[1][1] then
          end_text[1][1] = end_text[1][1]:gsub("[%s\t]+", "")
        end

        vim.list_extend(result, { { suffix, "UfoFoldedEllipsis" }, unpack(end_text) })
        table.insert(result, { padding, "" })
        return result
      end,
      provider_selector = function()
        return { "treesitter", "indent" }
      end,
    },
  },

  {
    "NvChad/nvim-colorizer.lua",
    ft = function()
      local plugin = require("lazy.core.config").spec.plugins["nvim-colorizer.lua"]
      local opts = require("lazy.core.plugin").values(plugin, "opts", false)
      return opts.filetypes or {}
    end,
    opts = {
      filetypes = { "vue", "css", "scss", "less", "html" },
      buftypes = { "*", "!prompt", "!popup" },
      user_default_options = {
        names = false,
        mode = "virtualtext",
        virtualtext = I.misc.palette .. " ",
      },
    },
  },

  {
    "stevearc/dressing.nvim",
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
    opts = function()
      local function get_hight(self, _, max_lines)
        local results = #self.finder.results
        local PADDING = 4
        local LIMIT = math.floor(max_lines / 2)
        return (results <= (LIMIT - PADDING) and results + PADDING or LIMIT)
      end

      return {
        input = {
          win_options = { winblend = 0 },
        },
        select = {
          telescope = require("telescope.themes").get_dropdown({
            layout_config = { height = get_hight },
          }),
          get_config = function(opts)
            if opts.kind == "codeaction" then
              return {
                backend = "telescope",
                telescope = require("telescope.themes").get_cursor({
                  layout_config = { height = get_hight },
                }),
              }
            end
          end,
        },
      }
    end,
  },
}

return M
