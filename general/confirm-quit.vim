
if exists("g:confirm_quit") || &cp
    finish
endif
let g:confirm_quit = 1

function! ConfirmQuit(writeFile)
    if (a:writeFile)
        if (expand("#")=="")
            echo "Can't save a file with no name."
            return
        endif
        write
    endif

    let l:confirmed = confirm("Do you really want to quit?", "&Yes\n&No", 2)
    if l:confirmed == 1
        quit
    endif
endfu

cnoremap <silent> q<cr>  call ConfirmQuit(0)<cr>
cnoremap <silent> wq<cr> call ConfirmQuit(1)<cr>
cnoremap <silent> x<cr> call ConfirmQuit(1)<cr>
