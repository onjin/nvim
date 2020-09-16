" Tmux/vim seamless movement {{{
function! TmuxMove(direction)
	let wnr = winnr()
	silent! execute 'wincmd ' . a:direction
	" If the winnr is still the same after we moved, it is the last pane
	if wnr == winnr()
		call system('tmux select-pane -' . tr(a:direction, 'phjkl', 'lLDUR'))
	end
endfunction

nnoremap <silent> <c-h> :call TmuxMove('h')<cr>
nnoremap <silent> <c-j> :call TmuxMove('j')<cr>
nnoremap <silent> <c-k> :call TmuxMove('k')<cr>
nnoremap <silent> <c-l> :call TmuxMove('l')<cr>
" Tmux/vim seamless movement }}}
