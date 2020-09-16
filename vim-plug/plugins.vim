if empty(glob('$VIMPATH/autoload/plug.vim'))
  silent !curl -fLo $VIMPATH/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.cache/vim/plugins')
	Plug 'NLKNguyen/papercolor-theme'

	Plug 'chriskempson/base16-shell'
	" Plug 'chriskempson/base16-vim'

	Plug 'editorconfig/editorconfig-vim'
	Plug 'vim-airline/vim-airline' 
	Plug 'vim-airline/vim-airline-themes'

	" reopen file at last position
	Plug 'dietsche/vim-lastplace'
	Plug 'Yggdroot/indentLine'  " indent lvl indicator

	" fuzzy finder
	Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
	Plug 'junegunn/fzf.vim'

	" python folding
	" Plug 'abarker/cyfolds', { 'do': 'cd python3 && python3 setup.py build_ext --inplace' }

	" documentation generator
	Plug 'kkoomen/vim-doge'

	Plug 'majutsushi/tagbar'

	Plug 'liuchengxu/vista.vim'

	Plug 'tmhedberg/matchit'
	Plug 'chaoren/vim-wordmotion'
	Plug 'michaeljsmith/vim-indent-object'
	Plug 'kana/vim-textobj-user'
	Plug 'bps/vim-textobj-python'

	Plug 'tpope/vim-fugitive'
	Plug 'wellle/tmux-complete.vim'

	Plug 'neoclide/coc.nvim', {'branch': 'release'}
	Plug 'honza/vim-snippets'

	Plug 'romainl/vim-cool'  " auto disable hlsearch when done searching

	Plug 'junegunn/limelight.vim'
	Plug 'junegunn/goyo.vim'

	Plug 'mattn/emmet-vim'

	Plug 'SirVer/ultisnips'
	Plug 'vim-scripts/Mark--Karkat'  " highlight words unser cursor <leader>m

	" automatically resize windows
	Plug 'camspiers/animate.vim'
	Plug 'camspiers/lens.vim'

	Plug 'vim-scripts/mako.vim'
	Plug 'metakirby5/codi.vim'

	" semantic python syntax
	if has('nvim')
		Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
	endif

	Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }

call plug#end()

" Automatically install missing plugins on startup
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif
