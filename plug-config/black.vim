" autocmd BufWritePre *.py execute ':Black'
let g:black_linelength = 120
let g:black#settings = {
    \ 'fast': 1,
    \ 'line_length': 120
\}
let g:python3_host_prog = $HOME . '/.vim/black/bin/python'
