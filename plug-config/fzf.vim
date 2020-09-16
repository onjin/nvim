noremap <Leader>b :Buffers<CR>
noremap <Leader>c :BTags<CR>

command! -bang -nargs=* GGrep
	\ call fzf#vim#grep('git grep --line-number '.shellescape(<q-args>), 0, <bang>0)

noremap <Leader>p :Files<CR>
noremap <C-p> :GFiles<CR>
noremap <leader>a :GGrep<CR>
noremap <S-f> :GGrep<CR>
noremap <S-t> :Tags<CR>

command! FZFMru call fzf#run({
\ 'source':  reverse(s:all_files()),
\ 'sink':    'edit',
\ 'options': '-m -x +s',
\ 'down':    '40%' })

function! s:all_files()
  return extend(
  \ filter(copy(v:oldfiles),
  \        "v:val !~ 'fugitive:\\|NERD_tree\\|^/tmp/\\|.git/'"),
  \ map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), 'bufname(v:val)'))
endfunction

noremap <Leader>u :FZFMru<CR>
