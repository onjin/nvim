-- luacheck: globals vim
vim.cmd("packadd packer.nvim")

local plugins = {
  ["lukas-reineke/indent-blankline.nvim"] = {
    opt = true,
    setup = function()
      require("core.lazy_load").on_file_open("indent-blankline.nvim")
    end,
    config = function()
      require("plugins.configs.others").blankline()
    end,
  },
  ["NvChad/nvim-colorizer.lua"] = {
    config = function()
      require("plugins.configs.others").colorizer()
    end,
  },
  -- git stuff
  ["lewis6991/gitsigns.nvim"] = {
    ft = "gitcommit",
    setup = function()
      require("core.lazy_load").gitsigns()
    end,
    config = function()
      require("plugins.configs.others").gitsigns()
    end,
  },
  ["tpope/vim-fugitive"] = {},
  ["tveskag/nvim-blame-line"] = {},

  ["lukas-reineke/lsp-format.nvim"] = {
    disable = true,
    config = function()
      require("plugins.configs.lsp_format")
    end,
  },
  ["mhartington/formatter.nvim"] = {
    disable = true,
    config = function()
      require("plugins.configs.formatter")
    end,
  },
  -- smart coding {{{
  ["github/copilot.vim"] = {
    disable = true,
  },
  -- smart coding }}}

  -- file managing , picker etc
  ["kyazdani42/nvim-tree.lua"] = {
    ft = "alpha",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    config = function()
      require("plugins.configs.nvimtree")
    end,
  },
  ["akinsho/toggleterm.nvim"] = {
    tag = "v2.*",
    config = function()
      require("plugins.configs.others").toggleterm()
    end,
  },
  -- sessions
  ["ahmedkhalf/project.nvim"] = {
    config = function()
      require("plugins.configs.others").project()
    end,
  },
  -- misc plugins

  -- automatically resize windows
  ["windwp/nvim-autopairs"] = {
    config = function()
      require("plugins.configs.others").autopairs()
    end,
  },
  ["goolord/alpha-nvim"] = {
    after = "base46",
    disable = true,
    config = function()
      require("plugins.configs.alpha")
    end,
  },
  ["numToStr/Comment.nvim"] = {
    module = "Comment",
    keys = { "gc", "gb" },
    config = function()
      require("plugins.configs.others").comment()
    end,
  },
  -- reopen file at last position
  ["dietsche/vim-lastplace"] = {},
  ["bagrat/vim-buffet"] = { disable = true },
  ["folke/todo-comments.nvim"] = {
    config = function()
      require("plugins.configs.others").todo_comments()
    end,
  },
  --[[ ["bennypowers/nvim-regexplainer"] = {
		config = function()
			require("plugins.configs.others").regexplainer()
		end,
		requires = {
			"nvim-treesitter/nvim-treesitter",
			"MunifTanjim/nui.nvim",
		},
	},
  --]]
  ["danymat/neogen"] = {
    config = function()
      require("plugins.configs.others").neogen()
    end,
  },
  -- tmux seamless navigation and clipboard integration
  ["aserowy/tmux.nvim"] = {
    config = function()
      require("plugins.configs.others").tmux()
    end,
  },
  --[[ ["CosmicNvim/cosmic-ui"] = {
		config = function()
			require("plugins.configs.others").cosmic_ui()
		end,
		requires = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
	},
  --]]

  ["glepnir/lspsaga.nvim"] = {
    branch = "main",
    config = function()
      require("plugins.configs.others").lspsaga()
    end,
  },
  -- highlight words unser cursor <leader>m
  ["inkarkat/vim-mark"] = {
    disable = true,
    requires = { "nkarkat/vim-ingo-library" },
  },
  ["t9md/vim-quickhl"] = {},
  -- testing
  ["nvim-neotest/neotest"] = {
    config = function()
      require("plugins.configs.neotest")
    end,
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-plenary",
      "nvim-neotest/neotest-vim-test",
      "vim-test/vim-test",
      "preservim/vimux",
    },
  },
  ["NTBBloodbath/rest.nvim"] = {
    config = function()
      require("plugins.configs.rest_nvim")
    end,
    requires = { "nvim-lua/plenary.nvim" },
  },
  ["iamcco/markdown-preview.nvim"] = {
    run = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
  -- better wordmotion (f.i. between CamelCaseWords)
  ["chaoren/vim-wordmotion"] = {},
  -- text objects and motions for python
  ["jeetsukumaran/vim-pythonsense"] = {},
  -- rust crates.io
  ["saecki/crates.nvim"] = {
    tag = "v0.3.0",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("plugins.configs.others").crates()
    end,
  },
  -- requirements.txt syntax
  ["raimon49/requirements.txt.vim"] = {},
  ["junegunn/limelight.vim"] = {},
  ["folke/twilight.nvim"] = {},
  -- Debugging
  ["mfussenegger/nvim-dap"] = {},
  ["mfussenegger/nvim-dap-python"] = {
    config = function()
      require("plugins.configs.dap").dappython()
    end,
  },
  ["rcarriga/nvim-dap-ui"] = {
    config = function()
      require("plugins.configs.dap").dapui()
    end,
  },
  ["freitass/todo.txt-vim"] = {},
  -- plantuml {{{
  ["weirongxu/plantuml-previewer.vim"] = {
    requires = {
      "tyru/open-browser.vim",
      "aklt/plantuml-syntax",
    },
  },
  -- plantuml }}}

  -- Only load whichkey after all the gui
  ["folke/which-key.nvim"] = {
    module = "which-key",
    config = function()
      require("plugins.configs.whichkey")
    end,
  },
  ["Asheq/close-buffers.vim"] = {},
  ["tweekmonster/startuptime.vim"] = {},
  ["Pocco81/true-zen.nvim"] = {
    config = function()
      require("plugins.configs.others").zen()
    end
  },

  ["~/.config/nvim/local/quickstart"] = {
    config = function()
      require('quickstart').setup({})
    end
  },
}

require("core.packer").run(plugins)
