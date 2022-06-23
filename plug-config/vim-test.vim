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
