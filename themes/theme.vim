" colorscheme PaperColor
set t_Co=256
set background=dark

" fix for colors in console/tmux
set t_ut=

highlight BadWhitespace ctermfg=darkred ctermbg=black guifg=#382424 guibg=black



let g:onedark_config = {
  \ 'style': 'darker',
  \ 'toggle_style_key': '<leader>ct',
  \ 'ending_tildes': v:true,
  \ 'diagnostics': {
    \ 'darker': v:false,
    \ 'background': v:true,
  \ },
\ }
highlight WinSeparator guibg=None
"colorscheme onedark

"let g:base16colorspace = 256
"let g:base16_shell_path = $VARPATH.'/plugins/base16-shell/'
" colorscheme base16-chalk
"

" Example config in VimScript
let g:tokyonight_style = "night"
let g:tokyonight_italic_functions = 1
let g:tokyonight_sidebars = [ "qf", "vista_kind", "terminal", "packer" ]

" Change the "hint" color to the "orange" color, and make the "error" color bright red
let g:tokyonight_colors = {
  \ 'hint': 'orange',
  \ 'error': '#ff0000'
\ }

" Load the colorscheme
colorscheme tokyonight
