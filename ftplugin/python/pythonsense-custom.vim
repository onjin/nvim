" let g:is_pythonsense_suppress_motion_keymaps = 1
" let g:is_pythonsense_alternate_motion_keymaps = 1

" map <buffer> ac <Plug>(PythonsenseOuterClassTextObject)
" map <buffer> ic <Plug>(PythonsenseInnerClassTextObject)
" map <buffer> af <Plug>(PythonsenseOuterFunctionTextObject)
" map <buffer> if <Plug>(PythonsenseInnerFunctionTextObject)
" map <buffer> ad <Plug>(PythonsenseOuterDocStringTextObject)
" map <buffer> id <Plug>(PythonsenseInnerDocStringTextObject)

map <buffer> <leader>nc <Plug>(PythonsenseStartOfNextPythonClass)
map <buffer> <leader>nC <Plug>(PythonsenseEndOfPythonClass)
map <buffer> <leader>pc <Plug>(PythonsenseStartOfPythonClass)
map <buffer> <leader>pC <Plug>(PythonsenseEndOfPreviousPythonClass)
map <buffer> <leader>nm <Plug>(PythonsenseStartOfNextPythonFunction)
map <buffer> <leader>nM <Plug>(PythonsenseEndOfPythonFunction)
map <buffer> <leader>pm <Plug>(PythonsenseStartOfPythonFunction)
map <buffer> <leader>pM <Plug>(PythonsenseEndOfPreviousPythonFunction)

map <buffer> g: <Plug>(PythonsensePyWhere)
map <buffer> <leader>cf :Black<cr>
