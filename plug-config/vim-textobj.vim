let g:textobj_python_no_default_key_mappings = 1

call textobj#user#map('python', {
      \   'class': {
      \     'select-a': '<buffer>ac',
      \     'select-i': '<buffer>ic',
      \     'move-n': '<buffer><c-S-Right>',
      \     'move-p': '<buffer><c-S-Left>',
      \   },
      \   'function': {
      \     'select-a': '<buffer>af',
      \     'select-i': '<buffer>if',
      \     'move-n': '<buffer><c-S-Up>',
      \     'move-p': '<buffer><c-S-Down>',
      \   }
      \ })
