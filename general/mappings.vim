
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

" create the `tags` file (may need to isntall ctags first)

" Now we can
" - use ^] to jump to tag under cursor
" - use g^] for ambigous tags
" - use ^t to jump back up the tag stack

" tab complete fuzzy tag search
nnoremap <Leader>j :tjump /

nnoremap - :Explore<CR>

" nnoremap ,e :e **/*<C-z><S-Tab>
" nnoremap ,f :find **/*<C-z><S-Tab>
"
nnoremap <Leader>ss :!isort %<CR>

command! ZoomToggle call s:ZoomToggle()
nnoremap <silent> <C-a>z :ZoomToggle<CR>

" conceal level
nnoremap <leader>c :setlocal <C-R>=&conceallevel ? 'conceallevel=0' : 'conceallevel=2'<CR><CR>
