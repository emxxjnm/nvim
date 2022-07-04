local fn = vim.fn
local cmd = vim.cmd

local PACKER_BOOTSTRAP = false

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
  print("Installing packer close and reopen Neovim...")
  cmd([[packadd packer.nvim]])
end

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init({
  display = {
    -- open_fn = function()
    --   return require("packer.util").float { border = "rounded" }
    -- end,
  },
})

-- Install your plugins here
return packer.startup(function(use)
  use("wbthomason/packer.nvim") -- Have packer manage itself

  use("lewis6991/impatient.nvim")

  use("nvim-lua/plenary.nvim")

  use("kyazdani42/nvim-web-devicons")

  use({
    "rcarriga/nvim-notify",
    -- disable = true,
    config = function()
      require("notify").setup({
        background_colour = "Normal",
        stages = "slide",
      })
      vim.notify = require("notify")
    end,
  })

  use({
    "folke/lua-dev.nvim",
    opt = true,
    module = "lua-dev",
  })

  -- welcome page
  use({
    "goolord/alpha-nvim",
    opt = true,
    event = "BufWinEnter",
    config = function()
      require("mvim.config.alpha").setup()
    end,
  })

  -- file explorer
  use({
    "kyazdani42/nvim-tree.lua",
    opt = true,
    cmd = {
      "NvimTreeToggle",
      "NvimTreeFocus",
      "NvimTreeFindFile",
      "NvimTreeFindFileToggle",
    },
    config = function()
      require("mvim.config.nvim-tree").setup()
    end,
  })

  -- telescope: search
  use({
    {
      "nvim-telescope/telescope.nvim",
      opt = true,
      cmd = "Telescope",
      module = "telescope",
      config = function()
        require("mvim.config.nvim-telescope").setup()
      end,
    },
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      run = "make",
      opt = true,
      after = "telescope.nvim",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
    {
      "nvim-telescope/telescope-live-grep-args.nvim",
      opt = true,
      after = "telescope.nvim",
      config = function()
        require("telescope").load_extension("live_grep_args")
      end,
    },
    {
      "ahmedkhalf/project.nvim",
      opt = true,
      after = "telescope.nvim",
      config = function()
        require("mvim.config.project").setup()
      end,
    },
  })

  -- treesitter
  use({
    {
      "nvim-treesitter/nvim-treesitter",
      opt = true,
      event = "BufRead",
      run = ":TSUpdate",
      config = function()
        require("mvim.config.nvim-treesitter").setup()
      end,
    },
    {
      "nvim-treesitter/playground",
      opt = true,
      cmd = "TSPlaygroundToggle",
      after = "nvim-treesitter",
    },
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      opt = true,
      after = "nvim-treesitter",
    },
    {
      "andymass/vim-matchup",
      opt = true,
      after = "nvim-treesitter",
      config = function()
        vim.g.matchup_matchparen_offscreen = {
          method = "popup",
          fullwidth = 1,
          highlight = "OffscreenMatchPopup",
        }
      end,
    },
    {
      "windwp/nvim-ts-autotag",
      opt = true,
      after = "nvim-treesitter",
    },
    {
      "windwp/nvim-autopairs",
      opt = true,
      after = "nvim-treesitter",
      config = function()
        require("mvim.config.nvim-autopairs").setup()
      end,
    },
  })

  -- lsp
  use({
    {
      "williamboman/nvim-lsp-installer",
    },
    {
      "neovim/nvim-lspconfig",
      opt = true,
      module = "lsp",
      after = "nvim-lsp-installer",
      config = function()
        require("mvim.lsp").setup()
      end,
    },
    {
      "ray-x/lsp_signature.nvim",
      opt = true,
      after = "nvim-lspconfig",
      config = function()
        require("lsp_signature").setup({
          bind = true,
          fix_pos = true,
          handler_opts = {
            border = "rounded",
          },
        })
      end,
    },
    {
      "jose-elias-alvarez/null-ls.nvim",
      opt = true,
      after = "nvim-lspconfig",
      config = function()
        require("mvim.lsp.extension").setup()
      end,
    },
  })

  -- cmp
  use({
    {
      "hrsh7th/nvim-cmp",
      config = function()
        require("mvim.config.nvim-cmp").setup()
      end,
      event = "InsertEnter *",
      requires = {
        {
          "L3MON4D3/LuaSnip",
          config = function()
            require("luasnip.loaders.from_vscode").lazy_load({
              paths = vim.fn.stdpath("config") .. "/snippets",
            })
          end,
        },
        {
          "hrsh7th/cmp-nvim-lsp",
        },
      },
    },
    {
      "saadparwaiz1/cmp_luasnip",
      opt = true,
      after = { "nvim-cmp", "LuaSnip" },
    },
    {
      "hrsh7th/cmp-buffer",
      opt = true,
      after = "nvim-cmp",
    },
    {
      "hrsh7th/cmp-path",
      opt = true,
      after = "nvim-cmp",
    },
    {
      "hrsh7th/cmp-nvim-lua",
      opt = true,
      after = "nvim-cmp",
    },
  })

  -- comment
  use({
    "numToStr/Comment.nvim",
    opt = true,
    event = "BufRead",
    config = function()
      require("Comment").setup()
    end,
  })

  -- markdown
  use({
    {
      "dhruvasagar/vim-table-mode",
      opt = true,
      cmd = { "TableModeToggle" },
      ft = { "markdown" },
    },
    {
      "iamcco/markdown-preview.nvim",
      run = "cd app && npm install",
      opt = true,
      ft = { "markdown" },
      cmd = { "MarkdownPreview", "MarkdownPreviewToggle" },
    },
  })

  -- debug adapter protocol
  use({
    {
      "mfussenegger/nvim-dap",
      opt = true,
      module = "dap",
      config = function()
        require("mvim.dap").setup()
      end,
    },
    {
      "rcarriga/nvim-dap-ui",
      opt = true,
      after = "nvim-dap",
      config = function()
        require("mvim.dap.ui").setup()
      end,
    },
    {
      "theHamsta/nvim-dap-virtual-text",
      opt = true,
      after = "nvim-dap",
      config = function()
        require("mvim.dap.virtual-text").setup()
      end,
    },
  })

  use({
    "github/copilot.vim",
    disable = true,
    setup = function()
      vim.g.copilot_no_tab_map = true
      vim.api.nvim_set_keymap("i", "<C-j>", "copilot#Accept('<CR>')", { silent = true, expr = true })
    end,
  })

  use({
    "tpope/vim-surround",
    opt = true,
    event = "BufReadPost",
  })

  -- undo history
  use({
    "mbbill/undotree",
    opt = true,
    event = "BufRead",
  })

  -- git
  use({
    {
      "lewis6991/gitsigns.nvim",
      tag = "release", -- To use the latest release
      event = "BufRead",
      config = function()
        require("mvim.config.gitsigns").setup()
      end,
    },
    {
      "sindrets/diffview.nvim",
      opt = true,
      cmd = {
        "DiffviewOpen",
        "DiffviewRefresh",
        "DiffviewFocusFiles",
        "DiffviewToggleFiles",
        "DiffviewFileHistory",
      },
      config = function()
        require("mvim.config.diffview").setup()
      end,
    },
    {
      "TimUntersberger/neogit",
      opt = true,
      cmd = "Neogit",
      config = [[require("mvim.config.neogit")]],
    },
  })

  use({
    "catppuccin/nvim",
    as = "catppuccin",
    config = function()
      require("mvim.config.nvim-catppuccin").setup()
    end,
  })

  -- termnail
  use({
    "akinsho/toggleterm.nvim",
    opt = true,
    module = "toggleterm",
    cmd = { "ToggleTerm", "TermExec" },
    config = function()
      require("mvim.config.toggleterm").setup()
    end,
  })

  -- status line
  use({
    "nvim-lualine/lualine.nvim",
    opt = true,
    after = "catppuccin",
    event = "BufRead",
    config = function()
      require("mvim.config.lualine").setup()
    end,
  })

  -- tab
  use({
    "akinsho/bufferline.nvim",
    tag = "*",
    opt = true,
    event = "BufRead",
    config = function()
      require("mvim.config.bufferline").setup()
    end,
  })

  -- highlight color
  use({
    "norcalli/nvim-colorizer.lua",
    opt = true,
    ft = {
      "css",
      "less",
      "scss",
      "javascript",
      "typescript",
      "html",
      "vue",
    },
    config = function()
      require("colorizer").setup({
        "css",
        "less",
        "scss",
        "javascript",
        "typescript",
        "html",
        "vue",
      })
    end,
  })

  -- like easymotion, but more powerful
  use({
    "phaazon/hop.nvim",
    opt = true,
    cmd = {
      "HopWord",
      "HopWordAC",
      "HopWordBC",
      "HopLine",
      "HopChar1",
      "HopChar1AC",
      "HopChar1BC",
      "HopChar2",
      "HopChar2AC",
      "HopChar2BC",
      "HopPattern",
      "HopPatternAC",
      "HopPatternBC",
      "HopChar1CurrentLineAC",
      "HopChar1CurrentLineBC",
      "HopChar1CurrentLine",
    },
    branch = "v1",
    config = function()
      require("hop").setup()
    end,
  })

  use({
    "lukas-reineke/indent-blankline.nvim",
    opt = true,
    event = "BufRead",
    config = function()
      require("indent_blankline").setup({
        show_current_context = true,
        char_list = { "┊" },
      })
    end,
  })

  -- outline
  use({
    "stevearc/aerial.nvim",
    opt = true,
    cmd = { "AerialToggle", "AerialOpen" },
    config = function()
      require("aerial").setup()
    end,
  })

  -- Misc
  use({
    "dstein64/vim-startuptime",
    opt = true,
    cmd = { "StartupTime" },
  })

  use({
    "wakatime/vim-wakatime",
    disable = true,
  })

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
