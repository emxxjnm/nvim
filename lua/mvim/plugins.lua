local fn = vim.fn
local cmd = vim.cmd

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  cmd [[packadd packer.nvim]]
end

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    -- open_fn = function()
    --   return require("packer.util").float { border = "rounded" }
    -- end,
  },
}

-- Install your plugins here
return packer.startup(function(use)
  use "wbthomason/packer.nvim" -- Have packer manage itself

  use 'lewis6991/impatient.nvim'

  -- speed up
  use {
    "nathom/filetype.nvim",
    config = [[require("mvim.config.filetype")]],
  }

  use {
    "nvim-lua/plenary.nvim",
    after = "packer.nvim",
  }

  use {
    "kyazdani42/nvim-web-devicons",
    after = "packer.nvim",
  }

  -- welcome page
  use {
    "goolord/alpha-nvim",
    opt = true,
    event = "BufWinEnter",
    config = [[require("mvim.config.alpha")]],
  }

  -- file explorer
  use {
    "kyazdani42/nvim-tree.lua",
    cmd = {
      "NvimTreeToggle",
      "NvimTreeFocus",
      "NvimTreeFindFile",
      "NvimTreeFindFileToggle",
    },
    config = [[require("mvim.config.nvim-tree")]],
  }

  -- telescope: search
  use {
    {
      "nvim-telescope/telescope.nvim",
      -- setup = [[require("config.telescope_setup")]],
      config = [[require("mvim.config.telescope")]],
      cmd = "Telescope",
      module = "telescope",
    },
    {
      "nvim-telescope/telescope-frecency.nvim",
      after = "telescope.nvim",
      requires = {
        "tami5/sqlite.lua",
      },
      config = function()
        require("telescope").load_extension("frecency")
      end,
    },
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      run = "make",
      after = "telescope.nvim",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
    {
      "nvim-telescope/telescope-ui-select.nvim",
      after = "telescope.nvim",
      config = function()
        require("telescope").load_extension("ui-select")
      end,
    },

    {
      "nvim-telescope/telescope-live-grep-raw.nvim",
      after = "telescope.nvim",
      config = function()
        require("telescope").load_extension("live_grep_raw")
      end,
    },
    {
      "ahmedkhalf/project.nvim",
      after = "telescope.nvim",
      config = [[require("mvim.config.project")]],
    },
  }

  -- treesitter
  use {
    {
      "nvim-treesitter/nvim-treesitter",
      opt = true,
      event = "BufRead",
      run = ":TSUpdate",
      config = [[require("mvim.config.nvim-treesitter")]],
    },
    {
      "windwp/nvim-ts-autotag",
      opt = true,
      ft = { "html", "vue", "javascriptreact", "typescriptreact" },
    },
    {
      "nvim-treesitter/playground",
      opt = true,
      cmd = "TSPlaygroundToggle",
    },
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      opt = true,
      after = "nvim-treesitter",
    },
    {
      "JoosepAlviste/nvim-ts-context-commentstring",
      opt = true,
      after = "nvim-treesitter",
    },
    {
      "andymass/vim-matchup",
      opt = true,
      after = "nvim-treesitter",
      config = function()
        vim.g.matchup_matchparen_offscreen = { method = "popup" }
      end,
    },
    {
      "windwp/nvim-autopairs",
      after = "nvim-treesitter",
      config = [[require("mvim.config.nvim-autopairs")]],
    },
  }

  -- lsp
  use {
    {
      "neovim/nvim-lspconfig",
      config = function()
        require("mvim.lsp").setup()
      end,
    },
    {
      "williamboman/nvim-lsp-installer",
    },
    {
      "ray-x/lsp_signature.nvim",
      after = "nvim-lspconfig",
    },
    -- {
    --   "jose-elias-alvarez/null-ls.nvim",
    -- },
  }

  -- cmp
  use {
    {
      "hrsh7th/nvim-cmp",
      config = function()
        require("mvim.config.nvim-cmp").setup()
      end,
      event = 'InsertEnter *',
      requires = {
        {
          "L3MON4D3/LuaSnip",
          config = [[require("mvim.config.luasnip")]],
        },
        {
          "hrsh7th/cmp-nvim-lsp",
        },
      },
    },
    {
      "saadparwaiz1/cmp_luasnip",
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
  }

  -- markdown
  use {
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
  }

  use {
    "folke/trouble.nvim",
    cmd = { "Trouble", "TroubleToggle" },
    config = [[require("mvim.config.trouble")]],
  }

  -- debug adapter protocol
  use {
    {
      "mfussenegger/nvim-dap",
      config = function()
        require("mvim.dap").setup()
      end,
      module = "dap",
    },
    {
      "rcarriga/nvim-dap-ui",
      -- after = "nvim-dap",
      config = [[require("mvim.dap.ui")]],
    },
    {
      "theHamsta/nvim-dap-virtual-text",
      after = "nvim-dap",
      config = [[require("mvim.dap.virtual-text")]],
    },
  }

  use {
    "github/copilot.vim",
    setup = function()
      vim.g.copilot_filetypes = {
        ["*"] = true,
        gitcommit = false,
        NeogitCommitMessage = false,
      }

      vim.cmd([[
        imap <silent><script><expr> <C-j> copilot#Accept("\<CR>")
        let g:copilot_no_tab_map = v:true
      ]])
    end,
  }

  use {
    "tpope/vim-surround",
    opt = true,
    event = "BufReadPost",
  }

  -- undo history
  use {
    "mbbill/undotree",
    event = "BufRead",
  }

  -- git
  use {
    {
      "lewis6991/gitsigns.nvim",
      tag = "release", -- To use the latest release
      event = "BufRead",
      config = [[require("mvim.config.gitsigns")]],
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
      config = [[require("mvim.config.diffview")]]
    },
    {
      "TimUntersberger/neogit",
      opt = true,
      cmd = "Neogit",
      config = [[require("mvim.config.neogit")]],
    }
  }

  -- scheme
  -- use {
  --   "projekt0n/github-nvim-theme",
  --   config = [[require("mvim.config.github-theme")]],
  -- }

  -- use {
  --   "folke/tokyonight.nvim",
  --   config = [[require("mvim.config.tokyonight")]]
  -- }

  use {
    "catppuccin/nvim",
    as = "catppuccin",
    config = [[require("mvim.config.catppuccin")]],
  }

  -- termnail
  use {
    "akinsho/toggleterm.nvim",
    opt = true,
    cmd = { "ToggleTerm", "TermExec" },
    -- event = { "CmdwinEnter", "CmdlineEnter" },
    config = [[require("mvim.config.toggleterm")]],
  }

  -- status line
  use {
    "nvim-lualine/lualine.nvim",
    opt = true,
    after = "catppuccin",
    event = "BufRead",
    config = [[require("mvim.config.lualine")]],
  }

  -- tab
  use {
    "akinsho/bufferline.nvim",
    tag = "*",
    opt = true,
    event = "BufRead",
    config = [[require("mvim.config.bufferline")]],
  }

  -- highlight color
  use {
    "norcalli/nvim-colorizer.lua",
    ft = { "css", "scss", "less", "javascript", "html", "vue", "typescipt" },
    config = function()
      require("colorizer").setup({
        "css",
        "less",
        "scss",
        "javascript",
        "typescript",
        "html",
        "vue"
      })
    end,
  }

  -- like easymotion, but more powerful
  use {
    "phaazon/hop.nvim",
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
    branch = "v1", -- optional but strongly recommended
    config = [[require("mvim.config.hop")]]
  }

  use {
    "lukas-reineke/indent-blankline.nvim",
    opt = true,
    event = "BufRead",
    config = [[require("mvim.config.indent-blankline")]]
  }

  -- outline
  use {
    "stevearc/aerial.nvim",
    cmd = { "AerialToggle", "AerialOpen" },
    config = function()
      require("aerial").setup()
    end,
  }

  -- use {
  --   "folke/which-key.nvim",
  --   opt = true,
  --   cmd = { "WhichKey" },
  --   config = [[require("mvim.config.which-key")]],
  -- }

  use {
    "dstein64/vim-startuptime",
    opt = true,
    cmd = { "StartupTime" },
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
