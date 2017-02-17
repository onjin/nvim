" enter the curren millenium
set nocompatible

let mapleader = ","

" Respect XDG
if isdirectory($XDG_CONFIG_HOME.'/vim')
	let $VIMPATH=expand('$XDG_CONFIG_HOME/vim')
	let $VARPATH=expand('$XDG_CACHE_HOME/vim')
else
	let $VIMPATH=expand('$HOME/.vim')
	let $VARPATH=expand('$HOME/.cache/vim')
endif

"
" Specify a directory for plugins
call plug#begin('~/.cache/vim/plugins')

Plug 'chriskempson/base16-shell'
let g:base16colorspace = 256
let g:base16_shell_path = $VARPATH.'/plugins/base16-shell/'

Plug 'morhetz/gruvbox'
let g:gruvbox_contrast_dark = 'hard'

Plug 'davidhalter/jedi-vim'

let g:jedi#popup_on_dot = 0
let g:jedi#use_splits_not_buffers = 'right'

Plug 'editorconfig/editorconfig-vim'

Plug 'vim-syntastic/syntastic'
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 2  " open manualy by :Errors, auto close
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1
set laststatus=2
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

Plug 'rafi/vim-tinyline'

Plug 'dietsche/vim-lastplace'

Plug 'hynek/vim-python-pep8-indent'
Plug 'kshenoy/vim-signature'
Plug 'ervandew/supertab'
let g:SuperTabDefaultCompletionType = "context"

" Track the engine.
Plug 'SirVer/ultisnips'

" Snippets are separated from the engine. Add this if you want them:
Plug 'honza/vim-snippets'

Plug 'nathanaelkane/vim-indent-guides'
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 1
let g:indent_guides_auto_colors = 1

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

Plug 'majutsushi/tagbar'
nnoremap <silent> tt :TagbarToggle<CR>
nnoremap <silent> to :TagbarOpenAutoClose<CR>
let g:tagbar_autofocus = 1

" If you want :UltiSnipsEdit to split your window.
" let g:UltiSnipsEditSplit="vertical"

call plug#end()
set mouse=nvi
set modeline
set report=0
set noerrorbells
set visualbell t_vb=         " Don't make any faces
set lazyredraw
set hidden
set fileformats=unix,dos,mac
set magic
set history=500
set synmaxcol=1000
syntax sync minlines=256
set ttyfast
set formatoptions+=1
set formatoptions-=t
if has('vim_starting')
	set encoding=utf-8
	scriptencoding utf-8
endif
" set viminfo='30,/100,:500,<10,@10,s10,h,n$VARPATH/viminfo
set undofile swapfile nobackup
set directory=$VARPATH/swap//,$VARPATH,~/tmp,/var/tmp,/tmp
set undodir=$VARPATH/undo//,$VARPATH,~/tmp,/var/tmp,/tmp
set backupdir=$VARPATH/backup/,$VARPATH,~/tmp,/var/tmp,/tmp
set viewdir=$VARPATH/view/
set nospell spellfile=$VIMPATH/spell/en.utf-8.add

" Don't backup files in temp directories or shm
if exists('&backupskip')
	set backupskip+=/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*,.vault.vim
endif

" Don't keep swap files in temp directories or shm
augroup swapskip
	autocmd!
	silent! autocmd BufNewFile,BufReadPre
		\ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*,.vault.vim
		\ setlocal noswapfile
augroup END

" Don't keep undo files in temp directories or shm
if has('persistent_undo')
	augroup undoskip
		autocmd!
		silent! autocmd BufWritePre
			\ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*,.vault.vim
			\ setlocal noundofile
	augroup END
endif

" Don't keep viminfo for files in temp directories or shm
augroup viminfoskip
	autocmd!
	silent! autocmd BufNewFile,BufReadPre
		\ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*,.vault.vim
		\ setlocal viminfo=
augroup END

set textwidth=80    " Text width maximum chars before wrapping
set colorcolumn=80
set expandtab       " Do expand tabs to spaces as default
set tabstop=2       " The number of spaces a tab is
set softtabstop=2   " While performing editing operations
set smarttab        " Tab insert blanks according to 'shiftwidth'
set autoindent      " Use same indenting on new lines
set smartindent     " Smart autoindenting on new lines
set shiftround      " Round indent to multiple of 'shiftwidth'
set shiftwidth=2    " Number of spaces to use in auto(indent)

set timeout ttimeout
set timeoutlen=750  " Time out on mappings
set ttimeoutlen=250 " Time out on key codes
set updatetime=1000 " Idle time to write swap

" Searching {{{
" ---------
set ignorecase      " Search ignoring case
set smartcase       " Keep case when searching with *
set infercase
set incsearch       " Incremental search
set hlsearch        " Highlight search results
set wrapscan        " Searches wrap around the end of the file
set showmatch       " Jump to matching bracket
set matchpairs+=<:> " Add HTML brackets to pair matching
set matchtime=1     " Tenths of a second to show the matching paren
set cpoptions-=m    " showmatch will wait 0.5s or until a char is typed
" Searching }}}
" Behavior {{{
" --------
set linebreak                   " Break long lines at 'breakat'
set breakat=\ \	;:,!?           " Long lines break chars
set nostartofline               " Cursor in same column for few commands
set whichwrap+=h,l,<,>,[,],~    " Move to following line on certain keys
set splitbelow splitright       " Splits open bottom right
set switchbuf=usetab,split      " Switch buffer behavior
set backspace=indent,eol,start  " Intuitive backspacing in insert mode
set diffopt=filler,iwhite       " Diff mode: show fillers, ignore white
set showfulltag                 " Show tag and tidy search in completion
set completeopt=menuone         " Show menu even for one item
set complete=.                  " No wins, buffs, tags, include scanning
set nowrap                      " No wrap by default

" }}}

" enable syntax an dpluginx (for netrw)
syntax enable
filetype plugin on

" Finding files {{{
"
" Usage:
"  :find some<tab>  # search files in cwd (recursive)
"  :find *<tab>  # search files in cwd (recursive)
"  :ls  # list open buffers
"  :edit file1.txt
"  :edit file2.txt
"  :b 2<enter>  # opens file.txt
"
" search down into subfolder
" provides tab-completion for all file-related tasks
set path+=**

" display all matching files when we tab complete
set wildmenu

" Finding files }}}

" TAG jumping {{{
" create the `tags` file (may need to isntall ctags first)
command! MakeTags !ctags -R

" Now we can
" - use ^] to jump to tag under cursor
" - use g^] for ambigous tags
" - use ^t to jump back up the tag stack

" TAG jumping }}}
"
" Autocomplete {{{
"
" ^x^n this file
" ^x^f filenames
" ^x^] for tags
" ^n for anything specifeid by the `complete` option
" Autocomplete }}}
"
"File browsing
let g:netrw_banner=0  " no annoying banner
let g:netrw_browse_split=4  " open in prior window
let g:netrw_altv=1  " splits to the right
let g:netrw_liststyle=3  " tree view
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\$\+'
let g:netrw_banner=0

set showcmd

autocmd Filetype html setlocal ts=2 sts=2 sw=2
autocmd Filetype ruby setlocal ts=2 sts=2 sw=2
autocmd Filetype javascript setlocal ts=4 sts=4 sw=4

autocmd Filetype python setlocal ts=4 sts=4 sw=4 foldmethod=syntax

set cursorline
set number
set noruler             " Disable default status ruler
set list                " Show hidden characters


" Vimscript file settings ---------------------- {{{
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker ts=2 sw=2 tw=80 noet
augroup END
" }}}

" theme {{{
set t_Co=256
set background=dark

colorscheme gruvbox
highlight BadWhitespace ctermfg=darkred ctermbg=black guifg=#382424 guibg=black


set guioptions=aci
set guifont=Anonymous\ Pro\ 12

" UI elements "{{{
set showbreak=↪
set fillchars=vert:│,fold:─
set listchars=tab:\⋮\ ,extends:⟫,precedes:⟪,nbsp:.,trail:·

" theme }}}

" mappings {{{
nnoremap <leader>re :edit $MYVIMRC<CR>
nnoremap <leader>rs :source $MYVIMRC<CR>

nnoremap <leader>/ :vsplit<CR>

" stop pressing ESC
inoremap jk <esc>
inoremap <esc> <nop>

" fast match inside (), '', and "" fi. cp, dp, cq
onoremap p i(
onoremap q i'
onoremap Q i"

" fast match next ()
onoremap ar :<c-u>normal! f(vi(<cr>
" mappings }}}

" nnoremap ,html :-1read $HOME/.vimsnippets.html<CR>3jwf>a
