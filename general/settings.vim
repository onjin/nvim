filetype plugin indent on
syntax on
set backspace=indent,eol,start		" Intuitive backspacing in insert mode
set hidden 												" hide not saved buffers

set undofile
set swapfile
set nobackup

if has('vim_starting')
	set encoding=utf-8
	scriptencoding utf-8
endif
" Disable menu.vim
if has('gui_running')
  set guioptions=Mc
endif

if has('nvim')
	set shada='30,/100,:50,<10,@10,s50,h,n$VARPATH/shada
else
	set viminfo='30,/100,:500,<10,@10,s10,h,n$VARPATH/viminfo
endif


set directory=$VARPATH/swap//,$VARPATH,~/tmp,/var/tmp,/tmp
set undodir=$VARPATH/undo//,$VARPATH,~/tmp,/var/tmp,/tmp
set backupdir=$VARPATH/backup/,$VARPATH,~/tmp,/var/tmp,/tmp
set viewdir=$VARPATH/view/
set nospell spellfile=$VIMPATH/spell/en.utf-8.add spelllang=en_us


" Finding files.
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

set shiftwidth=4                    " when using the >> or << commands, shift lines by 4 spaces 
set tabstop=4                            " set tabs to have 4 spaces 
set softtabstop=4                            " set tabs to have 4 spaces 
set autoindent                      " indent when moving to the next line while writing codeP
set expandtab                       " expand tabs into spaces 
set shiftround                      " Round indent to multiple of 'shiftwidth'

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

"
set linebreak                   " Break long lines at 'breakat'
set breakat=\ \	;:,!?           " Long lines break chars
set nostartofline               " Cursor in same column for few commands
set whichwrap+=h,l,<,>,[,],~    " Move to following line on certain keys
set splitbelow splitright       " Splits open bottom right
set switchbuf=usetab,split      " Switch buffer behavior
set diffopt=filler,iwhite       " Diff mode: show fillers, ignore white
set showfulltag                 " Show tag and tidy search in completion
set completeopt=menuone         " Show menu even for one item
set complete=.                  " No wins, buffs, tags, include scanning
set nowrap                      " No wrap by default

set showbreak=↪

set fillchars=vert:│,fold:─
set listchars=tab:\⋮\ ,extends:⟫,precedes:⟪,nbsp:.,trail:·

augroup filetype_mako
	autocmd BufNewFile,BufRead,BufReadPost *.mako :set filetype=mako
augroup END

let mapleader = ","
let g:maplocalleader = "\<Space>"
let g:python3_host_prog = '~/.pyenv/versions/neovim/bin/python3.9'
" Fix auto-indentation for YAML files
augroup yaml_fix
    autocmd!
    autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab indentkeys-=0# indentkeys-=<:>
augroup END

" automate saving/loading fold
" autocmd BufWinLeave *.* mkview
"autocmd BufWinEnter *.* silent loadview

" single global status line without win separators
set laststatus=3

" Cyfolds settings.
let cyfolds = 1 " Enable or disable loading the plugin.
"let cyfolds_fold_keywords = "class,def,async def,cclass,cdef,cpdef" " Cython.
let cyfolds_fold_keywords = "class,def,async def" " Python default.
let cyfolds_lines_of_module_docstrings = 20 " Lines to keep unfolded, -1 means keep all.
let cyfolds_lines_of_fun_and_class_docstrings = -1 " Lines to keep, -1 means keep all.
let cyfolds_start_in_manual_method = 1 " Default is to start in manual mode.
let cyfolds_no_initial_fold_calc = 0 " Whether to skip initial fold calculations.
let cyfolds_fix_syntax_highlighting_on_update = 1 " Redo syntax highlighting on all updates.
let cyfolds_update_all_windows_for_buffer = 1 " Update all windows for buffer, not just current.
let cyfolds_increase_toplevel_non_class_foldlevels = 0

" General folding settings.
set foldenable " Enable folding and show the current folds.
"set nofoldenable " Disable folding and show normal, unfolded text.
set foldcolumn=0 " The width of the fold-info column on the left, default is 0
set foldlevelstart=-1 " The initial foldlevel; 0 closes all, 99 closes none, -1 default.
set foldminlines=0 " Minimum number of lines in a fold; don't fold small things.
"set foldmethod=manual " Set for other file types if desired; Cyfolds ignores it for Python.
"
autocmd FileType python setlocal foldlevel=1
let b:cyfolds_suppress_insert_mode_switching = 0

function! SuperFoldToggle()
    " Force the fold on the current line to immediately open or close.  Unlike za
    " and zo it only takes one application to open any fold.  Unlike zO it does
    " not open recursively, it only opens the current fold.
    if foldclosed('.') == -1
        silent! foldclose
    else
        while foldclosed('.') != -1
            silent! foldopen
        endwhile
    endif
endfunction

" This sets the space bar to toggle folding and unfolding in normal mode.
nnoremap <silent> <space> :call SuperFoldToggle()<CR>

" hybrid numbering in command mode
:set number

:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
:  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
:augroup END
augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank({higroup="IncSearch", timeout=700})
augroup END

set exrc
