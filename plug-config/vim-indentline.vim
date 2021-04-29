autocmd VimEnter * if bufname('%') == '' | IndentLinesDisable | endif
autocmd TermOpen * IndentLinesDisable
let g:indentLine_fileTypeExclude = ['dashboard']
