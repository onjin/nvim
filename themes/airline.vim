let g:airline_powerline_fonts = 1
let g:airline_theme='papercolor'
let g:airline#extensions#tagbar#enabled = 1
let g:airline_highlighting_cache = 1"

" Just show the file name
" let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#branch#enabled= 1
let g:airline#extensions#hunks#enabled= 1
let g:airline#extensions#vista#enabled= 1
let g:airline#extensions#languageserver#enabled= 1

" Always show tabs
set showtabline=2


if $LSP == 'coc'
  let g:airline#extensions#coc#enabled= 1
endif
if $LSP == 'native'
  let g:airline#extensions#lsp#enabled= 1
  let g:airline#extensions#nvimlsp#enabled= 1
endif
