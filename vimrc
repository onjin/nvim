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

Plug 'dikiaap/minimalist'
let g:airline_theme='minimalist'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

Plug 'metakirby5/codi.vim'
let g:codi#width = 80
let g:codi#rightalign = 0

Plug 'lambdalisue/vim-pyenv'

Plug 'davidhalter/jedi-vim'

let g:jedi#popup_on_dot = 0
let g:jedi#use_splits_not_buffers = 'right'
let g:jedi#popup_select_first = 1
let g:jedi#max_doc_height = 40
let g:jedi#show_call_signatures = 0
let g:jedi#show_call_signatures_delay = 10


Plug 'editorconfig/editorconfig-vim'

" Plug 'rafi/vim-tinyline'
Plug 'vim-airline/vim-airline'
let g:airline_powerline_fonts = 0


" ale async linter {{{
Plug 'w0rp/ale'  " async linter - instead of syntastic

let g:ale_set_loclist = 1
let g:ale_set_quickfix = 0
let g:ale_open_list = 0
let g:airline#extensions#ale#enabled = 1
" ale async linter }}}

Plug 'Yggdroot/indentLine'  " indent lvl indicator

" syntastic {{{
" Plug 'vim-syntastic/syntastic'
" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 2  " open manualy by :Errors, auto close
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 1

" syntastic }}}
nnoremap <leader>e :lopen<CR>
nnoremap <leader>ee :lclose<CR>
nnoremap <C-e> :lnext<CR>
nnoremap <C-q> :lprev<CR>

Plug 'dietsche/vim-lastplace'

Plug 'hynek/vim-python-pep8-indent'

nnoremap <Leader>ss :!isort %<CR>
Plug 'kshenoy/vim-signature'
Plug 'ervandew/supertab'
let g:SuperTabDefaultCompletionType = "context"

" Track the engine.
Plug 'SirVer/ultisnips'
" If you want :UltiSnipsEdit to split your window.
" let g:UltiSnipsEditSplit="vertical"

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

Plug 'severin-lemaignan/vim-minimap'
nnoremap <silent> MM :MinimapToggle<CR>


let g:tagbar_autofocus = 1

Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'matze/vim-move'

Plug 'michaeljsmith/vim-indent-object'
Plug 'kana/vim-textobj-user'
Plug 'bps/vim-textobj-python'

Plug 'xolox/vim-misc'  " required by xolox/vim-notes
" Plug 'xolox/vim-notes'
" let g:notes_directories = ['~/Dropbox/Notes']
" let g:notes_suffix = '.md'
" let g:notes_title_sync = 'no'
Plug 'Rykka/riv.vim'

let riv_p_notes = {'name': 'Notes', 'path': '~/Dropbox/Notes'}
let riv_p_drafts = {'name': '@Drafts', 'path': '~/Dropbox/@Doc/@Drafts'}
let riv_p_working = {'name': '@Working', 'path': '~/Dropbox/@Doc/@Working'}
let riv_p_inbox = {'name': '@Inbox', 'path': '~/Dropbox/@Doc/@Inbox'}
let riv_p_archive = {'name': '@Archive', 'path': '~/Dropbox/@Doc/@Archive'}

let g:riv_projects = [riv_p_notes, riv_p_drafts, riv_p_inbox, riv_p_working, riv_p_archive]
let g:riv_global_leader = '<C-x>'

Plug 'chaoren/vim-wordmotion'

Plug 'mattn/emmet-vim'

Plug 'Rykka/InstantRst'
Plug 'shime/vim-livedown'

Plug 'tmhedberg/matchit'

Plug 'janko-m/vim-test'
Plug 'kassio/neoterm'

Plug 'Shougo/echodoc.vim'
set cmdheight=2
let g:echodoc_enable_at_startup	= 1

Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'vim-scripts/bash-support.vim'
Plug 'elzr/vim-json'
Plug 'benmills/vimux'
Plug 'vim-scripts/todo-txt.vim'  " support for todo.txt syntax
Plug 'vim-scripts/Mark--Karkat'  " highlight words unser cursor <leader>m
Plug 'jceb/vim-orgmode'          " vim orgmode
Plug 'tpope/vim-speeddating'     " - for orgmode
Plug 'mfukar/robotframework-vim'
Plug 'bagrat/vim-workspace'

Plug 'StanAngeloff/php.vim'
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'Quramy/tsuquyomi'
Plug 'flowtype/vim-flow'
" Plug 'fsharp/vim-fsharp'
" let g:fsharp_interactive_bin = '/usr/bin/fsharpi'
"

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

let g:VimuxOrientation = "h"
let g:VimuxHeight = "40"

map <Leader>R :VimuxPromptCommand<CR>
map <Leader>i :VimuxInspectRunner<CR>
map <Leader>z :VimuxZoomRunner<CR>

Plug 'mattn/calendar-vim'
Plug 'vimwiki/vimwiki'
" Set Vim Wiki to my Dropbox directory
let g:vimwiki_list = [{ 'path':'$HOME/Dropbox/vimwiki', 'syntax': 'markdown', 'ext': '.md'}]

Plug 'dleonard0/pony-vim-syntax'

if v:version >= 800
	Plug 'skywind3000/asyncrun.vim'
	Plug 'pedsm/sprint'
endif

Plug 'onjin/vim-guitar-tab-syntax'

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

if has('nvim')
	set shada='30,/100,:50,<10,@10,s50,h,n$VARPATH/shada
else
	set viminfo='30,/100,:500,<10,@10,s10,h,n$VARPATH/viminfo
endif

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
set wildmode=list:full
set wildignore=*.swp,*.bak,*~
set wildignore+=*.pyc,*.class,*.sln,*.min.*,*.map
set wildignore+=*/.git/**/*,*/.hg/**/*,*/.svn/**/*
set wildignore+=tags
set wildignore+=*.tar.*,*.gz,*.zip

nnoremap <Leader>p :find *
nnoremap <Leader>v :vert sfind *
nnoremap <Leader>t :tabfind *

" Finding files }}}

" TAG jumping {{{
" create the `tags` file (may need to isntall ctags first)
command! MakeTags !ctags -R

" Now we can
" - use ^] to jump to tag under cursor
" - use g^] for ambigous tags
" - use ^t to jump back up the tag stack

" tab complete fuzzy tag search
nnoremap <Leader>j :tjump /

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
let g:netrw_liststyle=3  " tree view
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\$\+'
"let g:netrw_browse_split=4  " open in prior window
let g:netrw_altv=1  " splits to the right
let g:netrw_winsize=25
" augroup ProjectDrawer
"   autocmd!
"   autocmd VimEnter * :Vexplore
" augroup END

nnoremap - :Explore<CR>

set showcmd

autocmd Filetype html setlocal ts=2 sts=2 sw=2
autocmd Filetype ruby setlocal ts=2 sts=2 sw=2
autocmd Filetype javascript setlocal ts=4 sts=4 sw=4
augroup javascript_folding
	au!
	au FileType javascript setlocal foldmethod=syntax
augroup END
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS

autocmd Filetype python setlocal ts=4 sts=4 sw=4 foldmethod=syntax omnifunc=jedi#completions


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

" fix for colors in console/tmux
set t_ut=

" theme }}}

" mappings {{{
nnoremap <leader>re :vsplit $MYVIMRC<CR>
nnoremap <leader>rs :source $MYVIMRC<CR>

nnoremap <leader>h :vsplit<CR>
nnoremap <leader>s :split<CR>

nnoremap <leader>f :windo diffthis<CR>
nnoremap <leader>ff :windo diffoff<CR>

" <Ctrl-l> redraws the screen and removes any search highlighting.
nnoremap <leader><space> :nohl<CR><C-l>


" buffers
set wildcharm=<C-z>
nnoremap <leader>b :buffer <C-z><S-Tab>
nnoremap <leader>B :vert sbuffer <C-z><S-Tab>
nnoremap <leader>l :ls<CR>
nnoremap <leader>c :bd<CR>
nnoremap <leader>, :bp<CR>
nnoremap <leader>. :bn<CR>
nnoremap <leader>1 :1b<CR>
nnoremap <leader>2 :2b<CR>
nnoremap <leader>3 :3b<CR>
nnoremap <leader>4 :4b<CR>
nnoremap <leader>5 :5b<CR>
nnoremap <leader>6 :6b<CR>
nnoremap <leader>7 :7b<CR>
nnoremap <leader>8 :8b<CR>
nnoremap <leader>9 :9b<CR>
nnoremap <leader>0 :0b<CR>

" quick switch buffer by number or part of filename
nnoremap gb :ls<CR>:b<Space>

" Tmux/vim seamless movement {{{
function! TmuxMove(direction)
	let wnr = winnr()
	silent! execute 'wincmd ' . a:direction
	" If the winnr is still the same after we moved, it is the last pane
	if wnr == winnr()
		call system('tmux select-pane -' . tr(a:direction, 'phjkl', 'lLDUR'))
	end
endfunction

nnoremap <silent> <c-h> :call TmuxMove('h')<cr>
nnoremap <silent> <c-j> :call TmuxMove('j')<cr>
nnoremap <silent> <c-k> :call TmuxMove('k')<cr>
nnoremap <silent> <c-l> :call TmuxMove('l')<cr>
" Tmux/vim seamless movement }}}
" Zoom / Restore window.
function! s:ZoomToggle() abort
	if exists('t:zoomed') && t:zoomed
		execute t:zoom_winrestcmd
		let t:zoomed = 0
	else
		let t:zoom_winrestcmd = winrestcmd()
		resize
		vertical resize
		let t:zoomed = 1
	endif
endfunction
command! ZoomToggle call s:ZoomToggle()
nnoremap <silent> <C-a>z :ZoomToggle<CR>

" # at ~/.tmux.conf put these lines
" is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
"     | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
" bind-key -n C-h if-shell "$is_vim" "send-keys C-h"  "select-pane -L"
" bind-key -n C-j if-shell "$is_vim" "send-keys C-j"  "select-pane -D"
" bind-key -n C-k if-shell "$is_vim" "send-keys C-k"  "select-pane -U"
" bind-key -n C-l if-shell "$is_vim" "send-keys C-l"  "select-pane -R"
" bind -n "C-\\" run-shell 'tmux-vim-select-pane -l'
" # Bring back clear screen under tmux prefix
" bind C-l send-keys 'C-l'


" stop pressing ESC
inoremap jk <esc>
" inoremap <esc> <nop>

" enter in normal mode adds one line
noremap <CR> o<ESC>

" fast match inside (), '', and "" fi. cp, dp, cq
onoremap p i(
onoremap q i'
onoremap Q i"

" registers :reg
nnoremap pp "*p

" fast match next ()
onoremap ar :<c-u>normal! f(vi(<cr>

nnoremap <C-s> :update<CR>
vnoremap <C-s> <C-C>:update<CR>
inoremap <C-s> <C-O>:update<CR>
" mappings }}}
"

" django {{{
let g:last_relative_dir = ''
nnoremap djm :call RelatedFile ("models.py")<cr>
nnoremap djv :call RelatedFile ("views.py")<cr>
nnoremap dju :call RelatedFile ("urls.py")<cr>
nnoremap dja :call RelatedFile ("admin.py")<cr>
nnoremap dje :call RelatedFile ("tests/")<cr>
nnoremap djE :call RelatedFile ("tests.py")<cr>
nnoremap djt :call RelatedFile ( "templates/" )<cr>
nnoremap djg :call RelatedFile ( "templatetags/" )<cr>
nnoremap djc :call RelatedFile ( "management/" )<cr>
nnoremap djS :e settings.py<cr>
nnoremap djU :e urls.py<cr>

noremap <Tab> :WSNext<CR>
noremap <S-Tab> :WSPrev<CR>
noremap <Leader><Tab> :WSClose<CR>
noremap <Leader><S-Tab> :WSClose!<CR>
noremap <C-t> :WSTabNew<CR>

cabbrev bonly WSBufOnly

fun! RelatedFile(file)
	" This is to check that the directory looks djangoish
	if filereadable(expand("%:h"). '/models.py') || isdirectory(expand("%:h") . "/templatetags/")
		exec "edit %:h/" . a:file
		let g:last_relative_dir = expand("%:h") . '/'
		return ''
	endif
	if g:last_relative_dir != ''
		exec "edit " . g:last_relative_dir . a:file
		return ''
	endif
	echo "Cant determine where relative file is : " . a:file
	return ''
endfun

fun! SetAppDir()
	if filereadable(expand("%:h"). '/models.py') || isdirectory(expand("%:h") . "/templatetags/")
		let g:last_relative_dir = expand("%:h") . '/'
		return ''
	endif
endfun
autocmd BufEnter *.py call SetAppDir()
" django }}}
"
if has('nvim')
	execute 'source' fnameescape($VIMPATH.'/neovim.vim')
endif

if jedi#init_python()
	function! s:jedi_auto_force_py_version() abort
		let major_version = pyenv#python#get_internal_major_version()
		call jedi#force_py_version(major_version)
	endfunction
	augroup vim-pyenv-custom-augroup
		autocmd! *
		autocmd User vim-pyenv-activate-post   call s:jedi_auto_force_py_version()
		autocmd User vim-pyenv-deactivate-post call s:jedi_auto_force_py_version()
	augroup END
endif


" quick navigate to last closed file of given type by global marks
augroup VIMRC
	autocmd!

	autocmd BufLeave *.css  normal! mC
	autocmd BufLeave *.html normal! mH
	autocmd BufLeave *.js   normal! mJ
	autocmd BufLeave *.py   normal! mP
augroup END

function! LinterStatus() abort
	let l:counts = ale#statusline#Count(bufnr(''))

	let l:all_errors = l:counts.error + l:counts.style_error
	let l:all_non_errors = l:counts.total - l:all_errors

	return l:counts.total == 0 ? 'OK' : printf(
	\   '%dW %dE',
	\   all_non_errors,
	\   all_errors
	\)
endfunction

set laststatus=2
set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%{LinterStatus()}
set statusline+=%*


let b:surround_{char2nr("v")} = "{{ \r }}"
let b:surround_{char2nr("{")} = "{{ \r }}"
let b:surround_{char2nr("%")} = "{% \r %}"
let b:surround_{char2nr("b")} = "{% block \1block name: \1 %}\r{% endblock \1\1 %}"
let b:surround_{char2nr("i")} = "{% if \1condition: \1 %}\r{% endif %}"
let b:surround_{char2nr("w")} = "{% with \1with: \1 %}\r{% endwith %}"
let b:surround_{char2nr("f")} = "{% for \1for loop: \1 %}\r{% endfor %}"
let b:surround_{char2nr("c")} = "{% comment %}\r{% endcomment %}"

function! ToggleEndChar(charToMatch)
    s/\v(.)$/\=submatch(1)==a:charToMatch ? '' : submatch(1).a:charToMatch
endfunction

nnoremap ;; :call ToggleEndChar(';')<CR>

" nnoremap ,html :-1read $HOME/.vimsnippets.html<CR>3jwf>a
" Command for git grep
" - fzf#vim#grep(command, with_column, [options], [fullscreen])
command! -bang -nargs=* GGrep
  \ call fzf#vim#grep('git grep --line-number '.shellescape(<q-args>), 0, <bang>0)

noremap <C-p> :FZF<CR>
noremap <leader>a :GGrep<CR>

