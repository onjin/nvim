set diffopt+=vertical
nnoremap <Leader>gdm :Gvdiffsplit master:%<CR>
nnoremap <Leader>gb :Git blame<CR>
nnoremap <Leader>gs :Git status<CR>
nnoremap <Leader>gl :Git llog -10<CR>

autocmd User fugitive 
  \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
  \   nnoremap <buffer> .. :edit %:h<CR> |
  \ endif
autocmd BufReadPost fugitive://* set bufhidden=delete
