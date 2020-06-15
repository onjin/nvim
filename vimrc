if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Respect XDG
if isdirectory($XDG_CONFIG_HOME.'/vim')
	let $VIMPATH=expand('$XDG_CONFIG_HOME/vim')
	let $VARPATH=expand('$XDG_CACHE_HOME/vim')
else
	let $VIMPATH=expand('$HOME/.vim')
	let $VARPATH=expand('$HOME/.cache/vim')
endif

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

" ==== Plugins {{{
call plug#begin('~/.cache/vim/plugins')

Plug 'NLKNguyen/papercolor-theme'

Plug 'chriskempson/base16-shell'
" Plug 'chriskempson/base16-vim'

Plug 'editorconfig/editorconfig-vim'
Plug 'vim-airline/vim-airline' 

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
let g:doge_doc_standard_python = 'google'

Plug 'majutsushi/tagbar'
nnoremap <silent> tt :TagbarToggle<CR>
nnoremap <silent> to :TagbarOpenAutoClose<CR>
let g:tagbar_autofocus = 1
let g:airline#extensions#tagbar#enabled = 1

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
let g:goyo_width = 120

Plug 'mattn/emmet-vim'

Plug 'SirVer/ultisnips'
Plug 'vim-scripts/Mark--Karkat'  " highlight words unser cursor <leader>m

" automatically resize windows
Plug 'camspiers/animate.vim'
Plug 'camspiers/lens.vim'

autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!


call plug#end()
" ==== Plugins }}}

" ==== Common configuration {{{
syntax enable                       " enable syntax highlighting
filetype plugin on
let mapleader = ","
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

" Autocomplete {{{
"
" ^x^n this file
" ^x^f filenames
" ^x^] for tags
" ^n for anything specifeid by the `complete` option
" Autocomplete }}}

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
nnoremap - :Explore<CR>

set showcmd

" nnoremap ,e :e **/*<C-z><S-Tab>
" nnoremap ,f :find **/*<C-z><S-Tab>

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

augroup filetype_vim
	autocmd!
	autocmd FileType vim setlocal foldmethod=marker ts=2 sw=2 tw=88 noet
augroup END
autocmd Filetype python setlocal ts=4 sts=4 sw=4

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

" ==== Common configuration }}}

" ==== Theme {{{
colorscheme PaperColor
set t_Co=256
set background=dark

" fix for colors in console/tmux
set t_ut=

highlight BadWhitespace ctermfg=darkred ctermbg=black guifg=#382424 guibg=black

set showbreak=↪
set fillchars=vert:│,fold:─
set listchars=tab:\⋮\ ,extends:⟫,precedes:⟪,nbsp:.,trail:·

let g:base16colorspace = 256
let g:base16_shell_path = $VARPATH.'/plugins/base16-shell/'
" ==== Theme }}}


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

" FZF {{{
noremap <Leader>b :Buffers<CR>
noremap <Leader>c :BTags<CR>

command! -bang -nargs=* GGrep
	\ call fzf#vim#grep('git grep --line-number '.shellescape(<q-args>), 0, <bang>0)

noremap <Leader>p :Files<CR>
noremap <C-p> :GFiles<CR>
noremap <leader>a :GGrep<CR>
noremap <S-f> :GGrep<CR>

command! FZFMru call fzf#run({
\ 'source':  reverse(s:all_files()),
\ 'sink':    'edit',
\ 'options': '-m -x +s',
\ 'down':    '40%' })

function! s:all_files()
  return extend(
  \ filter(copy(v:oldfiles),
  \        "v:val !~ 'fugitive:\\|NERD_tree\\|^/tmp/\\|.git/'"),
  \ map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), 'bufname(v:val)'))
endfunction

noremap <Leader>u :FZFMru<CR>

" FZF }}}

let g:airline_powerline_fonts = 0 

" Cyfolds settings {{{
let cyfolds = 1 " Enable or disable loading the plugin.
"let cyfolds_fold_keywords = "class,def,async def,cclass,cdef,cpdef" " Cython.
let cyfolds_fold_keywords = "class,def,async def" " Python default.
let cyfolds_lines_of_module_docstrings = 20 " Lines to keep unfolded, -1 means keep all.
let cyfolds_lines_of_fun_and_class_docstrings = -1 " Lines to keep, -1 means keep all.
let cyfolds_start_in_manual_method = 1 " Default is to start in manual mode.
let cyfolds_no_initial_fold_calc = 0 " Whether to skip initial fold calculations.
let cyfolds_fix_syntax_highlighting_on_update = 1 " Redo syntax highlighting on all updates.
" Cyfolds settings }}}

" navigate python code {{{
let g:textobj_python_no_default_key_mappings = 1

call textobj#user#map('python', {
      \   'class': {
      \     'select-a': '<buffer>ac',
      \     'select-i': '<buffer>ic',
      \     'move-n': '<buffer><c-S-Right>',
      \     'move-p': '<buffer><c-S-Left>',
      \   },
      \   'function': {
      \     'select-a': '<buffer>af',
      \     'select-i': '<buffer>if',
      \     'move-n': '<buffer><c-S-Up>',
      \     'move-p': '<buffer><c-S-Down>',
      \   }
      \ })
" navigate python code }}}

" COC {{{
let g:coc_global_extensions = ['coc-python', 'coc-ultisnips', 'coc-pairs', 'coc-yank', 'coc-prettier', 'coc-snippets', 'coc-html', 'coc-emmet', 'coc-bookmark']
" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end


" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current line.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Introduce function text object
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <TAB> for selections ranges.
" NOTE: Requires 'textDocument/selectionRange' support from the language server.
" coc-tsserver, coc-python are the examples of servers that support it.
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings using CoCList:
" Show all diagnostics.
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" List bookmarks
nnoremap <silent> <space>b  :<C-u>CocList bookmark<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
" COC }}}
" let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsSnippetDirectories = ['~/.vim/UltiSnips', 'UltiSnips']

" misc
nnoremap <Leader>ss :!isort %<CR>

" limelight for visual blocks
noremap <Leader>ll :Limelight!!<CR>
nmap <Leader>l <Plug>(Limelight)
xmap <Leader>l <Plug>(Limelight)

" bookmarks
nmap <Leader>bj <Plug>(coc-bookmark-next)
nmap <Leader>bk <Plug>(coc-bookmark-prev)
nmap <Leader>bb <Plug>(coc-bookmark-annotate)
nmap <Leader>bb <Plug>(coc-bookmark-toggle)

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

" lens / autoresize {{{
let g:lens#width_resize_max = 120
" lens / autoresize }}}

"
let g:EditorConfig_max_line_indicator = "line"
