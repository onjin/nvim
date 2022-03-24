" :Grep - search and then open the window
command! -nargs=+ Grep execute 'silent grep! <args>' | copen

" Go to the previous location
nnoremap <leader>qp :cprev<CR>

" Go to the next location
nnoremap <leader>qn :cnext<CR>

" Show the quickfix window
nnoremap <Leader>qo :copen<CR>

" Hide the quickfix window
nnoremap <Leader>qc :cclose<CR>

function! QuickfixMapping()
  " Go to the previous location and stay in the quickfix window
  nnoremap <buffer> K :cprev<CR>zz<C-w>w

  " Go to the next location and stay in the quickfix window
  nnoremap <buffer> J :cnext<CR>zz<C-w>w

  " Make the quickfix list modifiable
  nnoremap <buffer> <leader>m :set modifiable<CR>

  " Save the changes in the quickfix window
  nnoremap <buffer> <leader>w :cgetbuffer<CR>:cclose<CR>:copen<CR>

  " Begin the search and replace
  nnoremap <buffer> <leader>r :cdo s/// \| update<C-Left><C-Left><Left><Left><Left>
endfunction

augroup quickfix_group
    autocmd!
    autocmd filetype qf call QuickfixMapping()
augroup END
