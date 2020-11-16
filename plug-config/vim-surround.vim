
" vim-surround with 3 backticks for code (only works for whole line)
" TODO: Make this works on part of a line too
vnoremap S3` <esc>`<O<esc>S```<esc>`>o<esc>S```<esc>k$

" vim-surround with 3 quotes for python block comment (only works for whole line)
" TODO: Make this works on part of a line too
vnoremap S3" <esc>`<O<esc>S"""<esc>`>o<esc>S"""<esc>k$
