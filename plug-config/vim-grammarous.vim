let g:grammarous#default_comments_only_filetypes = {
	\ '*' : 1, 'help' : 0, 'markdown' : 0, 'text': 0
\ }
let g:grammarous#use_vim_spelllang = 1

" Check file grammar
nnoremap <silent> <Leader>cg :GrammarousCheck<CR>

let g:grammarous#hooks = {}
function! g:grammarous#hooks.on_check(errs) abort
    nmap <buffer><Leader>ew <Plug>(grammarous-move-to-info-window)
    nmap <buffer><Leader>ee <Plug>(grammarous-open-info-window)
    nmap <buffer><Leader>en <Plug>(grammarous-move-to-next-error)
    nmap <buffer><Leader>ep <Plug>(grammarous-move-to-previous-error)
    nmap <buffer><Leader>ef <Plug>(grammarous-fixit)
    nmap <buffer><Leader>er <Plug>(grammarous-remove-error)
    nmap <buffer><Leader>ed <Plug>(grammarous-disable-rule)
    nmap <buffer><Leader>eq <Plug>(grammarous-close-info-window)
endfunction

function! g:grammarous#hooks.on_reset(errs) abort
    nunmap <buffer><Leader>ew
    nunmap <buffer><Leader>ee
    nunmap <buffer><Leader>en
    nunmap <buffer><Leader>ep
    nunmap <buffer><Leader>ef
    nunmap <buffer><Leader>er
    nunmap <buffer><Leader>ed
    nunmap <buffer><Leader>eq
endfunction
