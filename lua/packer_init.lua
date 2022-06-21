-- Automatically install packer
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
local map = require('utils').map

if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({
    'git',
    'clone',
    '--depth',
    '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path
  })
end

-- Autocommand that reloads neovim whenever you save the packer_init.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost packer_init.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, 'packer')
if not status_ok then
  return
end

return require('packer').startup({function(use)
    -- Color Theme
    use { 'arcticicestudio/nord-vim' }
    use { 'crispybaccoon/fantastic.vim' }
    use { 'navarasu/onedark.nvim' }
    use { 'NLKNguyen/papercolor-theme' }
    use { 'rakr/vim-one' }
    use { 'sonph/onehalf', rtp = 'vim' }
    use { 'tomasiser/vim-code-dark' }

    use {'sheerun/vim-polyglot'}

    -- more colors
    -- use {'chriskempson/base16-shell'}
    -- use {'chriskempson/base16-vim'}

    use {'folke/tokyonight.nvim'}

    -- Support .editorconfig file
    use {'editorconfig/editorconfig-vim'}

    -- status line framework
    use {'nvim-lualine/lualine.nvim'}
    -- use {'arkav/lualine-lsp-progress'}
    -- use {'vim-airline/vim-airline' }
    -- use {'vim-airline/vim-airline-themes'}

    -- reopen file at last position
    use {'dietsche/vim-lastplace'}

    -- :lcd to project root on open buffer
    use {'airblade/vim-rooter'}

    -- indent lvl indicator
    use {'Yggdroot/indentLine'  }

    -- fuzzy finder {{{

    use {'nvim-lua/plenary.nvim'}
    use {'nvim-telescope/telescope.nvim'}
    use {
        "nvim-telescope/telescope-frecency.nvim",
        requires = {"tami5/sqlite.lua"}
    }
    use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    use {'nvim-telescope/telescope-media-files.nvim'}
    use {'nvim-telescope/telescope-github.nvim'} -- gh-cli
    use { "nvim-telescope/telescope-file-browser.nvim" }
    -- fuzzy finder }}}

    -- documentation generator
    -- use {'kkoomen/vim-doge', { 'do': { -> doge#install() } }}
    use {'danymat/neogen'}

    -- right sidebar with classes/functions/variables from current buffer
    -- use {'majutsushi/tagbar'}

    -- tagbar replacement with LSP support
    use {'liuchengxu/vista.vim'}

    -- extended matching for the % operator
    use {'tmhedberg/matchit'}

    -- better wordmotion (f.i. between CamelCaseWords)
    use {'chaoren/vim-wordmotion'}

    -- a convenient way to select and operate on various types of objects
    use {'michaeljsmith/vim-indent-object'}

    -- create your own text objects without pain
    use {'kana/vim-textobj-user'}
    use {'tpope/vim-surround'}

    -- SQL
    use {'lifepillar/pgsql.vim'}
    -- let g:sql_type_default = 'pgsql' # force all `.sql` to postgres

    -- git utils
    use {'tpope/vim-fugitive'}
    use {'airblade/vim-gitgutter'     }-- A Vim plugin which shows a git diff in the sign column.

    use {'wellle/tmux-complete.vim'		}-- coc complete from tmux panes
    use {'tmux-plugins/vim-tmux'			}-- tmux syntax
    use {'preservim/vimux'						}-- manageg tmux from vim

    use {'kyazdani42/nvim-tree.lua'}
    use {'windwp/nvim-autopairs',
        config = function() require("nvim-autopairs").setup {}
        end
    }

    -- LSP Support
    use {'neovim/nvim-lspconfig'}
    use {'williamboman/nvim-lsp-installer'}

    -- Autocompletion
    use {'hrsh7th/nvim-cmp'}
    use {'hrsh7th/cmp-buffer'}
    use {'hrsh7th/cmp-path'}
    use {'saadparwaiz1/cmp_luasnip'}
    use {'hrsh7th/cmp-nvim-lsp'}
    use {'hrsh7th/cmp-nvim-lua'}

    use {'hrsh7th/cmp-calc'}
    use {'andersevenrud/cmp-tmux'}
    use {'hrsh7th/cmp-copilot'}
    use {'hrsh7th/cmp-emoji'}

    --  Snippets
    use {'L3MON4D3/LuaSnip'}
    use {'rafamadriz/friendly-snippets'}

    use {'VonHeikemen/lsp-zero.nvim'}

    use {'honza/vim-snippets'}
    use {'https://github.com/OmniSharp/omnisharp-vim'  }-- for goto definition

    use {'romainl/vim-cool'  }-- auto disable hlsearch when done searching

    use {'junegunn/limelight.vim'}
    use {'junegunn/goyo.vim'}

    use {'mattn/emmet-vim'  }-- html/css magic macros
    use {'turbio/bracey.vim', run = 'npm install --prefix server'}  -- html live preview by :Bracey

    use {'inkarkat/vim-ingo-library'  }-- required by vim-mark
    use {'inkarkat/vim-mark'  }-- highlight words unser cursor <leader>m
    use {'borisbrodski/vim-highlight-hero'}

    use {'freitass/todo.txt-vim'  }-- TODO.txt support
    use {'folke/todo-comments.nvim',
        config = function() require("todo-comments").setup()
        end
    }

    use {'SirVer/ultisnips'}

    -- documents management
    -- use {'fmoralesc/vim-pad', { 'branch': 'devel' } ^ notes management}
    use {'vim-pandoc/vim-pandoc'}
    use {'vim-pandoc/vim-pandoc-syntax'}
    use {'dhruvasagar/vim-table-mode'  }-- <leader>tm to start creating tables

    use { "iamcco/markdown-preview.nvim", run = "cd app && npm install", setup = function() vim.g.mkdp_filetypes = { "markdown" } end, ft = { "markdown" }, }
    use {'chrisbra/NrrwRgn'}

    use {'osohq/polar.vim'}

    -- automatically resize windows
    use {'camspiers/animate.vim'}
    use {'camspiers/lens.vim'}

    use {'vim-scripts/mako.vim'}
    use {'metakirby5/codi.vim'}

    use {'rcarriga/nvim-notify',
        config = function() require("notify").setup({level='info'})
        require('telescope').load_extension('notify')
        end
    }
    use {'j-hui/fidget.nvim',
        config = function() require("fidget").setup()
        end
    }

    -- python folding
    -- use {'abarker/cyfolds', { 'do': 'cd python3 && python3 ./compile.py' }}

    -- Python files autoformat using `black`
    use {'psf/black'}
    -- use {'psf/black', { 'tag': '19.10b0' }}

    -- use {'bps/vim-textobj-python'}
    use {'jeetsukumaran/vim-pythonsense'  }-- replacement for vim_textobj-python
    use {'raimon49/requirements.txt.vim'}
    -- use {'ivanov/vim-ipython'  # lack of python 3 support}
    -- use {'wmvanvliet/jupyter-vim'}

    -- Debugging
    use {'mfussenegger/nvim-dap'}
    use {'mfussenegger/nvim-dap-python'}
    use {'rcarriga/nvim-dap-ui'}

    -- semantic python syntax
    -- if has('nvim')
    -- 	use {'numirias/semshi', {'do': ':UpdateRemotePlugins'}}
    -- endif
    -- semantic syntax
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }
    use { 'nvim-treesitter/playground' }
    use {'romgrk/nvim-treesitter-context'}

    -- grammary checker
    use {'rhysd/vim-grammarous'}

    -- visual help for leader keys
    use {
        "folke/which-key.nvim",
        config = function()
            require("which-key").setup {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
        end
    }
    use {'hauleth/vim-backscratch'  }-- :Scratch buffers

    -- nice icons
    use {'ryanoasis/vim-devicons'}

    -- customizable starting window
    -- use {'mhinz/vim-startify'}
    use {'glepnir/dashboard-nvim'}

    -- takes your buffers and tabs, and shows them combined in the tabline
    use {'bagrat/vim-buffet'}

    -- rockstart language syntax
    use {'sirosen/vim-rockstar'}

    use {'vim-test/vim-test'}
    use {
        "nvim-neotest/neotest",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "antoinemadec/FixCursorHold.nvim"
        }
    }

    use {'github/copilot.vim'}

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end,
config = {
    display = {
        open_fn = require('packer.util').float,
    }
}}
)
