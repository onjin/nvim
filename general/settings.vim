let mapleader = ","
let g:maplocalleader = "\<Space>"

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
set spell spellfile=$VIMPATH/spell/en.utf-8.add spelllang=en_us


syntax enable                       " enable syntax highlighting
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
" Finding files }}}
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

autocmd FileType html,htmldjango,css EmmetInstall

set showcmd

set number                          " show line numbers 

set ts=4                            " set tabs to have 4 spaces 
set autoindent                      " indent when moving to the next line while writing codeP
set expandtab                       " expand tabs into spaces 
set shiftwidth=4                    " when using the >> or << commands, shift lines by 4 spaces 
set shiftround                      " Round indent to multiple of 'shiftwidth'
set shiftwidth=2                    " Number of spaces to use in auto(indent)

set ignorecase                      " Search ignoring case
set smartcase                       " Keep case when searching with *
set showmatch                       " show the matching part of the pair for [] {} and ()
set hlsearch                        " enable higligting search results|
set incsearch                       " enable incremental search
set wrapscan                        " Searches wrap around the end of the file
set showmatch                       " Jump to matching bracket
set matchpairs+=<:>                 " Add HTML brackets to pair matching
set matchtime=1                     " Tenths of a second to show the matching paren
set cpoptions-=m                    " showmatch will wait 0.5s or until a char is typed

" set colorcolumn=120                  " mark column
set cursorline                      " show a visual line under the cursor's current line 

set foldenable
"set nofoldenable                    " Disable folding and show normal, unfolded text.
set foldcolumn=0                    " The width of the fold-info column on the left, default is 0
set foldlevelstart=-1               " The initial foldlevel; 0 closes all, 99 closes none, -1 default.
set foldminlines=0                  " Minimum number of lines in a fold; don't fold small things.
"set foldmethod=manual               " Set for other file types if desired; Cyfolds ignores it for Python.
"
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

set showbreak=↪
set fillchars=vert:│,fold:─
set listchars=tab:\⋮\ ,extends:⟫,precedes:⟪,nbsp:.,trail:·

augroup filetype_vim
	autocmd!
	autocmd FileType vim setlocal foldmethod=marker ts=2 sw=2 tw=88 noet
augroup END
autocmd Filetype python setlocal ts=4 sts=4 sw=4

augroup filetype_mako
	autocmd BufNewFile,BufRead,BufReadPost *.mako :set filetype=mako
augroup END
