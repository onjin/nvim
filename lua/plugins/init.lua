vim.cmd("packadd packer.nvim")

local plugins = {
	["nvim-lua/plenary.nvim"] = { module = "plenary" },
	["wbthomason/packer.nvim"] = {},

	["rcarriga/nvim-notify"] = {
		after = "plenary.vim",
		as = "notify",
		config = function()
			require("plugins.configs.others").notify()
		end,
	},
	["j-hui/fidget.nvim"] = {
		config = function()
			require("plugins.configs.others").fidget()
		end,
	},

	["catppuccin/nvim"] = {
		as = "catppuccin",
		requires = { "lukas-reineke/indent-blankline.nvim" },
		config = function()
			require("plugins.configs.catppuccin")
		end,
	},

	["kyazdani42/nvim-web-devicons"] = {
		module = "nvim-web-devicons",
		config = function()
			require("plugins.configs.others").devicons()
		end,
	},

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
		opt = true,
		setup = function()
			require("core.lazy_load").colorizer()
		end,
		config = function()
			require("plugins.configs.others").colorizer()
		end,
	},

	["nvim-treesitter/nvim-treesitter"] = {
		module = "nvim-treesitter",
		setup = function()
			require("core.lazy_load").on_file_open("nvim-treesitter")
		end,
		cmd = require("core.lazy_load").treesitter_cmds,
		run = ":TSUpdate",
		config = function()
			require("plugins.configs.treesitter")
		end,
		requires = {
			"romgrk/nvim-treesitter-context",
		},
	},

	["nvim-lualine/lualine.nvim"] = {
		config = function()
			require("plugins.configs.lualine")
		end,
	},

	-- Support .editorconfig file
	["editorconfig/editorconfig-vim"] = {},

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

	-- lsp stuff

	["williamboman/nvim-lsp-installer"] = {
		opt = true,
		cmd = require("core.lazy_load").lsp_cmds,
		setup = function()
			require("core.lazy_load").on_file_open("nvim-lsp-installer")
		end,
	},

	["neovim/nvim-lspconfig"] = {
		after = "nvim-lsp-installer",
		module = "lspconfig",
		config = function()
			require("plugins.configs.lsp_installer")
			require("plugins.configs.lspconfig")
		end,
	},
	["ray-x/lsp_signature.nvim"] = {
		config = function()
			require("plugins.configs.others").lsp_signature()
		end,
	},

	-- load luasnips + cmp related in insert mode only

	["rafamadriz/friendly-snippets"] = {
		module = "cmp_nvim_lsp",
		event = "InsertEnter",
	},

	["hrsh7th/nvim-cmp"] = {
		after = "friendly-snippets",
		config = function()
			require("plugins.configs.cmp")
		end,
	},

	["L3MON4D3/LuaSnip"] = {
		wants = "friendly-snippets",
		after = "nvim-cmp",
		config = function()
			require("plugins.configs.others").luasnip()
		end,
	},

	["saadparwaiz1/cmp_luasnip"] = {
		after = "LuaSnip",
	},
	["lukas-reineke/lsp-format.nvim"] = {
		config = function()
			require("plugins.configs.lsp_format")
		end,
	},

	["hrsh7th/cmp-nvim-lua"] = {
		after = "cmp_luasnip",
	},

	["hrsh7th/cmp-nvim-lsp"] = {
		after = "cmp-nvim-lua",
	},

	["hrsh7th/cmp-buffer"] = {
		after = "cmp-nvim-lsp",
	},

	["hrsh7th/cmp-path"] = {
		after = "cmp-buffer",
	},

	["hrsh7th/cmp-emoji"] = {
		after = "cmp-path",
	},

	["hrsh7th/cmp-calc"] = {
		after = "cmp-emoji",
	},

	["davidsierradz/cmp-conventionalcommits"] = {
		after = "cmp_luasnip",
	},

	--[[["tzachar/cmp-tabnine"] = {
      after = "friendly-snippets",
      run='./install.sh',
      requires = 'hrsh7th/nvim-cmp'
   },]]
	-- file managing , picker etc
	["kyazdani42/nvim-tree.lua"] = {
		ft = "alpha",
		cmd = { "NvimTreeToggle", "NvimTreeFocus" },
		config = function()
			require("plugins.configs.nvimtree")
		end,
	},

	-- sessions
	["ahmedkhalf/project.nvim"] = {
		config = function()
			require("plugins.configs.others").project()
		end,
	},
	["rmagatti/auto-session"] = {
		after = "plenary.nvim",
		config = function()
			require("plugins.configs.others").auto_session()
		end,
		requires = {
			"nvim-lua/plenary.nvim",
		},
	},
	["rmagatti/session-lens"] = {
		after = "plenary.nvim",
		config = function()
			require("plugins.configs.others").session_lens()
		end,
		requires = {
			"rmagatti/auto-session",
		},
	},

	-- misc plugins

	-- automatically resize windows
	["camspiers/animate.vim"] = {},
	["camspiers/lens.vim"] = {},
	["windwp/nvim-autopairs"] = {
		after = "nvim-cmp",
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
	["bagrat/vim-buffet"] = {},

	["folke/todo-comments.nvim"] = {
		config = function()
			require("plugins.configs.others").todo_comments()
		end,
	},
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
	["CosmicNvim/cosmic-ui"] = {
		config = function()
			require("plugins.configs.others").cosmic_ui()
		end,
		requires = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
	},
	-- highlight words unser cursor <leader>m
	["inkarkat/vim-mark"] = {},

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

	["nvim-telescope/telescope.nvim"] = {
		config = function()
			require("plugins.configs.telescope")
		end,
		requires = {
			"nvim-telescope/telescope-file-browser.nvim",
			"nvim-telescope/telescope-github.nvim",
		},
	},

	-- Only load whichkey after all the gui
	["folke/which-key.nvim"] = {
		module = "which-key",
		config = function()
			require("plugins.configs.whichkey")
		end,
	},

	--[[


  -- fuzzy finder {{{

  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use { 'nvim-telescope/telescope-github.nvim' } -- gh-cli
  use {  }
  use { 'nvim-telescope/telescope-project.nvim' }
  use { 'cljoly/telescope-repo.nvim' }
  -- fuzzy finder }}}
  use {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons"
  }

  -- tagbar replacement with LSP support
  use { 'liuchengxu/vista.vim' }

  -- extended matching for the % operator
  use { 'tmhedberg/matchit' }

  -- better wordmotion (f.i. between CamelCaseWords)
  use { 'chaoren/vim-wordmotion' }

  -- a convenient way to select and operate on various types of objects
  use { 'michaeljsmith/vim-indent-object' }

  -- create your own text objects without pain
  use { 'kana/vim-textobj-user' }
  use { 'tpope/vim-surround' }

  -- SQL
  use { 'lifepillar/pgsql.vim' }
  -- let g:sql_type_default = 'pgsql' # force all `.sql` to postgres

  -- git utils
  use { 'tpope/vim-fugitive' }
  use { 'airblade/vim-gitgutter' } -- A Vim plugin which shows a git diff in the sign column.

  --  Snippets

  use { 'romainl/vim-cool' } -- auto disable hlsearch when done searching

  use { 'junegunn/limelight.vim' }
  use { 'junegunn/goyo.vim' }

	-- plugin for live html, css, and javascript editing in vim
  use { 'turbio/bracey.vim', run = 'npm install --prefix server' } -- html live preview by :Bracey

  use { 'inkarkat/vim-ingo-library' } -- required by vim-mark
  use { 'inkarkat/vim-mark' } -- highlight words unser cursor <leader>m
  use { 'borisbrodski/vim-highlight-hero' }

  use { 'freitass/todo.txt-vim' } -- TODO.txt support

  -- documents management
  -- use {'fmoralesc/vim-pad', { 'branch': 'devel' } ^ notes management}
  use { 'vim-pandoc/vim-pandoc' }
  use { 'vim-pandoc/vim-pandoc-syntax' }
  use { 'dhruvasagar/vim-table-mode' } -- <leader>tm to start creating tables

  use { "iamcco/markdown-preview.nvim", run = "cd app && npm install",
    setup = function() vim.g.mkdp_filetypes = { "markdown" } end, ft = { "markdown" }, }
  use { 'chrisbra/NrrwRgn' }

  use { 'osohq/polar.vim' }

  -- automatically resize windows
  use { 'camspiers/animate.vim' }
  use { 'camspiers/lens.vim' }

  use { 'vim-scripts/mako.vim' }
  use { 'metakirby5/codi.vim' }


  -- python folding
  -- use {'abarker/cyfolds', { 'do': 'cd python3 && python3 ./compile.py' }}

  -- Python files autoformat using `black`
  use { 'psf/black' }
  -- use {'psf/black', { 'tag': '19.10b0' }}

  -- use {'bps/vim-textobj-python'}
  use { 'jeetsukumaran/vim-pythonsense' } -- replacement for vim_textobj-python
  use { 'raimon49/requirements.txt.vim' }
  -- use {'ivanov/vim-ipython'  # lack of python 3 support}
  -- use {'wmvanvliet/jupyter-vim'}

  -- Debugging
  use { 'mfussenegger/nvim-dap' }
  use { 'mfussenegger/nvim-dap-python' }
  use { 'rcarriga/nvim-dap-ui' }

  -- semantic python syntax
  -- if has('nvim')
  -- 	use {'numirias/semshi', {'do': ':UpdateRemotePlugins'}}
  -- endif
  -- semantic syntax
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
  }
  use { 'nvim-treesitter/playground' }
  use { 'romgrk/nvim-treesitter-context' }

  -- grammary checker
  use { 'rhysd/vim-grammarous' }

  -- visual help for leader keys
  use { 'hauleth/vim-backscratch' } -- :Scratch buffers

  -- customizable starting window
  -- use {'mhinz/vim-startify'}
  use { 'glepnir/dashboard-nvim' }


  use { 'skywind3000/asyncrun.vim' }
  use {
  }
  -- use { 'diepm/vim-rest-console' }
  use {
  }

  use { 'github/copilot.vim' }
  use 'wakatime/vim-wakatime'
--]]
}

require("core.packer").run(plugins)
