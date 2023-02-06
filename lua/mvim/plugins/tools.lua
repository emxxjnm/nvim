local function get_hight(self, _, max_lines)
  local results = #self.finder.results
  local PADDING = 4 -- this represents the size of the telescope window
  local LIMIT = math.floor(max_lines / 2)
  return (results <= (LIMIT - PADDING) and results + PADDING or LIMIT)
end

local M = {

  -- library used by other plugins
  { "nvim-lua/plenary.nvim", lazy = true },

  -- icons
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    commit = "a421d183ef37dfa13f51a5805bed2381aebf9080",
  },

  -- ui components
  { "MunifTanjim/nui.nvim", lazy = true },

  -- undotree
  { "mbbill/undotree", event = "VeryLazy" },

  -- surround
  {
    "kylechui/nvim-surround",
    event = "BufRead",
    config = true,
  },

  -- commnet
  {
    "numToStr/Comment.nvim",
    -- event = "BufRead",
    event = "VeryLazy",
    opts = {
      ignore = "^$",
      pre_hook = function(ctx)
        local utils = require("Comment.utils")
        local type = ctx.ctype == utils.ctype.linewise and "__default" or "__multiline"
        local location = nil
        if ctx.ctype == utils.ctype.blockwise then
          location = require("ts_context_commentstring.utils").get_cursor_location()
        elseif ctx.cmotion == utils.cmotion.v or ctx.cmotion == utils.cmotion.V then
          location = require("ts_context_commentstring.utils").get_visual_start_location()
        end

        return require("ts_context_commentstring.internal").calculate_commentstring({
          key = type,
          location = location,
        })
      end,
    },
  },

  -- easily jump to any location and enhanced f/t motions for Leap
  {
    "ggandor/leap.nvim",
    event = "VeryLazy",
    keys = {
      { "s", "<Plug>(leap-forward)", remap = true, desc = "Jump forward" },
      { "S", "<Plug>(leap-backward)", remap = true, desc = "Jump backward" },
    },
    dependencies = {
      "ggandor/flit.nvim",
      keys = { "f", "F" },
      opts = {
        labeled_modes = "nvo",
      },
    },
    opts = {
      equivalence_classes = { " \t\r\n", "([{", ")]}", "`\"'" },
    },
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPost",
    opts = {
      char = mo.styles.icons.documents.indent,
      char_list = { mo.styles.icons.documents.dash_indent },
      show_current_context = true,
      show_first_indent_level = false,
      filetype_exclude = { "help", "alpha", "neo-tree", "lazy" },
    },
  },

  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    event = "BufReadPost",
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
        local result = {}
        local suffix = (" %s [%d]"):format(mo.styles.icons.misc.ellipsis, end_lnum - lnum)
        local cur_width = 0
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
              suffix = suffix .. (" "):rep(target_width - cur_width - chunk_width)
            end
            break
          end
          cur_width = cur_width + chunk_width
        end

        table.insert(result, { suffix, "UfoFoldedEllipsis" })
        return result
      end,
    },
    init = function()
      vim.keymap.set("n", "zR", function()
        require("ufo").openAllFolds()
      end, { desc = "Open all folds" })
      vim.keymap.set("n", "zM", function()
        require("ufo").closeAllFolds()
      end, { desc = "Close all folds" })
    end,
  },

  {
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
      filetypes = {
        "css",
        "vue",
        "scss",
        "less",
        "html",
        "lua",
      },
      buftypes = {
        "*",
        "!prompt",
        "!popup",
      },
      user_default_options = {
        names = false,
        mode = "virtualtext",
        virtualtext = mo.styles.icons.misc.cloud .. " ",
      },
    },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = {
        presets = {
          operators = false,
          motions = false,
          text_objects = false,
          windows = false,
          nav = false,
          z = true,
          g = false,
        },
      },
      icons = {
        breadcrumb = mo.styles.icons.misc.double_right,
        separator = mo.styles.icons.misc.gg .. " ",
        group = mo.styles.icons.misc.plus,
      },
      window = {
        border = mo.styles.border,
      },
      layout = {
        spacing = 5,
        align = "center",
      },
      show_help = false,
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.register({
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },
        ["<leader>"] = {
          c = { name = "+code" },
          f = { name = "+find" },
          g = { name = "+git" },
        },
      })
    end,
  },

  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
      input = {
        relative = "editor",
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
    },
  },
}

return M
