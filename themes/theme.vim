" colorscheme PaperColor
set t_Co=256
set background=dark

" fix for colors in console/tmux
set t_ut=

highlight BadWhitespace ctermfg=darkred ctermbg=black guifg=#382424 guibg=black


let g:base16colorspace = 256
let g:base16_shell_path = $VARPATH.'/plugins/base16-shell/'

let g:onedark_config = {
  \ 'style': 'darker',
  \ 'toggle_style_key': '<leader>ct',
  \ 'ending_tildes': v:true,
  \ 'diagnostics': {
    \ 'darker': v:false,
    \ 'background': v:true,
  \ },
\ }
"colorscheme onedark
colorscheme base16-chalk
highlight WinSeparator guibg=None
