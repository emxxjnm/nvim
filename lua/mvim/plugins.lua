local fn = vim.fn
local cmd = vim.cmd

local PACKER_BOOTSTRAP

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
  auto_reload_compiled = true,
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

  -- welcome page
  use({
    "goolord/alpha-nvim",
    config = function()
      require("mvim.config.alpha").setup()
    end,
  })

  -- file explorer
  use({
    "kyazdani42/nvim-tree.lua",
    config = function()
      require("mvim.config.nvim-tree").setup()
    end,
  })

  -- telescope: search
  use({
    {
      "nvim-telescope/telescope.nvim",
      config = function()
        require("mvim.config.telescope").setup()
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
      "nvim-telescope/telescope-live-grep-args.nvim",
      after = "telescope.nvim",
      config = function()
        require("telescope").load_extension("live_grep_args")
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
      "ahmedkhalf/project.nvim",
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
      run = ":TSUpdate",
      config = function()
        require("mvim.config.nvim-treesitter").setup()
      end,
    },
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      after = "nvim-treesitter",
    },
    {
      "andymass/vim-matchup",
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
      after = "nvim-treesitter",
    },
    {
      "windwp/nvim-autopairs",
      after = "nvim-treesitter",
      config = function()
        require("mvim.config.nvim-autopairs").setup()
      end,
    },
  })

  -- lsp
  use({
    "williamboman/nvim-lsp-installer",
    "neovim/nvim-lspconfig",
    "ray-x/lsp_signature.nvim",
    "jose-elias-alvarez/null-ls.nvim",
    "folke/lua-dev.nvim",
    "b0o/SchemaStore.nvim",
  })

  -- cmp
  use({
    {
      "hrsh7th/nvim-cmp",
      config = function()
        require("mvim.config.nvim-cmp").setup()
      end,
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
      after = { "nvim-cmp", "LuaSnip" },
    },
    {
      "hrsh7th/cmp-buffer",
      after = "nvim-cmp",
    },
    {
      "hrsh7th/cmp-path",
      after = "nvim-cmp",
    },
    {
      "hrsh7th/cmp-nvim-lua",
      after = "nvim-cmp",
    },
  })

  -- comment
  use({
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  })

  -- markdown
  use({
    {
      "dhruvasagar/vim-table-mode",
      cmd = { "TableModeToggle" },
      ft = { "markdown" },
    },
    {
      "iamcco/markdown-preview.nvim",
      run = "cd app && npm install",
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

  use("tpope/vim-surround")

  -- undo history
  use("mbbill/undotree")

  -- git
  use({
    "lewis6991/gitsigns.nvim",
    config = function()
      require("mvim.config.gitsigns").setup()
    end,
  })

  -- schemea/theme
  use({
    "catppuccin/nvim",
    as = "catppuccin",
    config = function()
      vim.g.catppuccin_flavour = "macchiato"
      require("mvim.config.catppuccin").setup()
      vim.cmd("colorscheme catppuccin")
    end,
  })

  -- termnail
  use({
    "akinsho/toggleterm.nvim",
    config = function()
      require("mvim.config.toggleterm").setup()
    end,
  })

  -- status line
  use({
    "nvim-lualine/lualine.nvim",
    after = "catppuccin",
    config = function()
      require("mvim.config.lualine").setup()
    end,
  })

  -- tab
  use({
    "akinsho/bufferline.nvim",
    config = function()
      require("mvim.config.bufferline").setup()
    end,
  })

  -- highlight color
  use({
    "norcalli/nvim-colorizer.lua",
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
    config = function()
      require("hop").setup()
    end,
  })

  use({
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("indent_blankline").setup({
        show_current_context = true,
        char_list = { "┊" },
      })
    end,
  })

  -- Misc
  use({
    "dstein64/vim-startuptime",
    opt = true,
    cmd = { "StartupTime" },
  })

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
