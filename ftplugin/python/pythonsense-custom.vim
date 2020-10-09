" let g:is_pythonsense_suppress_motion_keymaps = 1

map <buffer> ac <Plug>(PythonsenseOuterClassTextObject)
map <buffer> ic <Plug>(PythonsenseInnerClassTextObject)
map <buffer> af <Plug>(PythonsenseOuterFunctionTextObject)
map <buffer> if <Plug>(PythonsenseInnerFunctionTextObject)
map <buffer> ad <Plug>(PythonsenseOuterDocStringTextObject)
map <buffer> id <Plug>(PythonsenseInnerDocStringTextObject)

map <buffer> ]] <Plug>(PythonsenseStartOfNextPythonClass)
map <buffer> ][ <Plug>(PythonsenseEndOfPythonClass)
map <buffer> [[ <Plug>(PythonsenseStartOfPythonClass)
map <buffer> [] <Plug>(PythonsenseEndOfPreviousPythonClass)
map <buffer> ]@ <Plug>(PythonsenseStartOfNextPythonFunction)
map <buffer> ]! <Plug>(PythonsenseEndOfPythonFunction)
map <buffer> [@ <Plug>(PythonsenseStartOfPythonFunction)
map <buffer> [! <Plug>(PythonsenseEndOfPreviousPythonFunction)

map <buffer> g: <Plug>(PythonsensePyWhere)
