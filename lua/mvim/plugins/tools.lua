local function get_hight(self, _, max_lines)
  local results = #self.finder.results
  local PADDING = 4 -- this represents the size of the telescope window
  local LIMIT = math.floor(max_lines / 2)
  return (results <= (LIMIT - PADDING) and results + PADDING or LIMIT)
end

local M = {
  -- library used by other plugins
  "nvim-lua/plenary.nvim",
  "kyazdani42/nvim-web-devicons",
  "MunifTanjim/nui.nvim",

  -- undotree
  {
    "mbbill/undotree",
    event = "VeryLazy",
  },

  -- surround
  {
    "kylechui/nvim-surround",
    event = "BufRead",
    config = true,
  },

  -- commnet
  {
    "numToStr/Comment.nvim",
    event = "BufRead",
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
    event = "BufReadPre",
    opts = {
      char = mo.style.icons.documents.indent,
      char_list = { mo.style.icons.documents.dash_indent },
      show_current_context = true,
      show_first_indent_level = false,
      filetype_exclude = { "help", "alpha", "neo-tree", "lazy" },
    },
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
        virtualtext = mo.style.icons.misc.cloud .. " ",
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
        breadcrumb = mo.style.icons.misc.double_right,
        separator = mo.style.icons.misc.gg .. " ",
        group = mo.style.icons.misc.plus,
      },
      window = {
        border = mo.style.border.current,
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
        ["<leader>"] = {
          f = { name = "+Telescope" },
          g = { name = "+Git" },
          s = { name = "+Split" },
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
