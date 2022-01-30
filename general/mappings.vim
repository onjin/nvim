
" stop pressing ESC
inoremap jk <esc>
" inoremap <esc> <nop>

" enter in normal mode adds one line
" noremap <CR> o<ESC>

" fast match inside (), '', and "" fi. cp, dp, cq
onoremap p i(
onoremap q i'
onoremap Q i"

" registers :reg
nnoremap pp "*p


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
nnoremap <Leader>cs :!isort %<CR>

command! ZoomToggle call s:ZoomToggle()
nnoremap <silent> <C-a>z :ZoomToggle<CR>

" conceal level
nnoremap <leader>vc :setlocal <C-R>=&conceallevel ? 'conceallevel=0' : 'conceallevel=2'<CR><CR>

" write modeline
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>

" allow to use `.` on visual selections
vnoremap . :norm.<CR>

noremap <Leader>bn :bn<CR>
noremap <Leader>bp :bp<CR>

noremap <Leader><Tab> :bn <CR>
noremap <Leader><S-Tab> :bp<CR>

" debug higlight file entry
nnoremap <Leader>dh :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
