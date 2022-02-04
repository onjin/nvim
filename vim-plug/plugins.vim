if empty(glob('$VIMPATH/autoload/plug.vim'))
  silent !curl -fLo $VIMPATH/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.cache/vim/plugins')
  " Color Theme
	Plug 'NLKNguyen/papercolor-theme'
	Plug 'navarasu/onedark.nvim'
	Plug 'tomasiser/vim-code-dark'
	Plug 'sheerun/vim-polyglot'

	" more colors
	Plug 'chriskempson/base16-shell'
	Plug 'chriskempson/base16-vim'
	
	" Support .editorconfig file
	Plug 'editorconfig/editorconfig-vim'

	" status line framework
	Plug 'vim-airline/vim-airline' 
	Plug 'vim-airline/vim-airline-themes'

	" reopen file at last position
	Plug 'dietsche/vim-lastplace'

	" :lcd to project root on open buffer
  Plug 'airblade/vim-rooter'

	" indent lvl indicator
	Plug 'Yggdroot/indentLine'  

	" fuzzy finder
	Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
	" Plug 'junegunn/fzf.vim'

	Plug 'nvim-lua/plenary.nvim'
	Plug 'nvim-telescope/telescope.nvim'
	Plug 'nvim-telescope/telescope-frecency.nvim'  "history
	Plug 'nvim-telescope/telescope-github.nvim'

	" documentation generator
	"Plug 'kkoomen/vim-doge', { 'do': { -> doge#install() } }

	" right sidebar with classes/functions/variables from current buffer
	" Plug 'majutsushi/tagbar'

	" tagbar replacement with LSP support
	Plug 'liuchengxu/vista.vim'

	" extended matching for the % operator
	Plug 'tmhedberg/matchit'

	" better wordmotion (f.i. between CamelCaseWords)
	Plug 'chaoren/vim-wordmotion'

	" a convenient way to select and operate on various types of objects 
	Plug 'michaeljsmith/vim-indent-object'

	" create your own text objects without pain
	Plug 'kana/vim-textobj-user'
	Plug 'tpope/vim-surround'

	" git utils"
	Plug 'tpope/vim-fugitive'
	Plug 'airblade/vim-gitgutter'     " A Vim plugin which shows a git diff in the sign column.

	Plug 'wellle/tmux-complete.vim'		" coc complete from tmux panes
  Plug 'tmux-plugins/vim-tmux'			" tmux syntax
	Plug 'preservim/vimux'						" manageg tmux from vim"

	Plug 'neoclide/coc.nvim', {'branch': 'release'}
	Plug 'honza/vim-snippets'
	Plug 'https://github.com/OmniSharp/omnisharp-vim'  " for goto definition

	Plug 'romainl/vim-cool'  " auto disable hlsearch when done searching

	Plug 'junegunn/limelight.vim'
	Plug 'junegunn/goyo.vim'

	Plug 'mattn/emmet-vim'  " html/css magic macros
	Plug 'turbio/bracey.vim', {'do': 'npm install --prefix server'}  " html live preview by :Bracey"

	Plug 'inkarkat/vim-ingo-library'  " required by vim-mark
	Plug 'inkarkat/vim-mark'  " highlight words unser cursor <leader>m
	Plug 'borisbrodski/vim-highlight-hero'

	Plug 'freitass/todo.txt-vim'  " TODO.txt support

	Plug 'SirVer/ultisnips'

	" documents management
	Plug 'renerocksai/telekasten.nvim'
	" Plug 'fmoralesc/vim-pad', { 'branch': 'devel' } " notes management
	Plug 'vim-pandoc/vim-pandoc'
	Plug 'vim-pandoc/vim-pandoc-syntax'
  Plug 'dhruvasagar/vim-table-mode'  " <leader>tm to start creating tables
  Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }	" markdowns / diagrams
	Plug 'chrisbra/NrrwRgn'

	" automatically resize windows
	Plug 'camspiers/animate.vim'
	Plug 'camspiers/lens.vim'

	Plug 'vim-scripts/mako.vim'
	Plug 'metakirby5/codi.vim'

	" python folding
	" Plug 'abarker/cyfolds', { 'do': 'cd python3 && python3 setup.py build_ext --inplace' }
	"
	" Python files autoformat using `black`
	" Plug 'psf/black', { 'tag': '20.8b1' }
	" Plug 'psf/black', { 'tag': '19.10b0' }
	" Plug 'averms/black-nvim'

	" Plug 'bps/vim-textobj-python'
	Plug 'jeetsukumaran/vim-pythonsense'  " replacement for vim_textobj-python
	" Plug 'ivanov/vim-ipython'  " lack of python 3 support
	" Plug 'wmvanvliet/jupyter-vim'

	" semantic python syntax
	" if has('nvim')
	" 	Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
	" endif
	" semantic syntax
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update- testing instead of semshi plugin
  Plug 'romgrk/nvim-treesitter-context'

	" grammary checker
  Plug 'rhysd/vim-grammarous'

	" visual help for leader keys
	Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }

	Plug 'hauleth/vim-backscratch'  " :Scratch buffers

	" nice icons
	Plug 'ryanoasis/vim-devicons'

	" customizable starting window
	" Plug 'mhinz/vim-startify'
	Plug 'glepnir/dashboard-nvim'

  " takes your buffers and tabs, and shows them combined in the tabline  
	Plug 'bagrat/vim-buffet'

	" rockstart language syntax
	Plug 'sirosen/vim-rockstar'

	Plug 'vim-test/vim-test'

	Plug 'github/copilot.vim'


call plug#end()

" Automatically install missing plugins on startup
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif
