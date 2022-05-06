" for neovim
"let test#neovim#term_position = "topleft"
"let test#neovim#term_position = "vert"
let test#neovim#term_position = "vert"
" or for Vim8
let test#vim#term_position = "vert"

" requires https://github.com/preservim/vimux
let test#strategy = "vimux"
let g:VimuxOrientation = "h"
let g:VimuxHeight = "50"

" these "Ctrl mappings" work well when Caps Lock is mapped to Ctrl
nmap <Leader>Tn :TestNearest<CR>
nmap <Leader>Tf :TestFile<CR>
nmap <Leader>Ta :TestSuite<CR>
nmap <Leader>Tl :TestLast<CR>
nmap <Leader>Tg :TestVisit<CR>

" vim-ultest
"let g:ultest_use_pty = 1
let test#python#pytest#options = "--color=yes"
nmap ]t <Plug>(ultest-next-fail)
nmap [t <Plug>(ultest-prev-fail)
nmap <Leader>ts :UltestSummary<CR>
nmap <Leader>tc :UltestClear<CR>
nmap <Leader>to :UltestOutput<CR>

nmap <Leader>tn :UltestNearest<CR>
nmap <Leader>tf :Ultest<CR>
nmap <Leader>tl :UltestLast<CR>
