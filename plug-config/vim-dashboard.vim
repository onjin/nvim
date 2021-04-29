let g:dashboard_default_executive ='fzf'
autocmd FileType dashboard set showtabline=0 | autocmd WinLeave <buffer> set showtabline=2

let g:dashboard_custom_header = [
      \ '',
      \
      \ '          ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ',
      \ '          ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ',
      \ '          ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ',
      \ '          ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ',
      \ '          ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ',
      \ '          ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ',
      \ '',
      \ '',
      \ "    .o oOOOOOOOo                                            0OOOo",
      \ "    Ob.OOOOOOOo  OOOo.      oOOo.                      .adOOOOOOO",
      \ "    OboO000000000000.OOo. .oOOOOOo.    OOOo.oOOOOOo..0000000000OO",
      \ "    OOP.oOOOOOOOOOOO 0POOOOOOOOOOOo.   `0OOOOOOOOOP,OOOOOOOOOOOB'",
      \ "    `O'OOOO'     `OOOOo\"OOOOOOOOOOO` .adOOOOOOOOO\"oOOO'    `OOOOo",
      \ "    .OOOO'            `OOOOOOOOOOOOOOOOOOOOOOOOOO'            `OO",
      \ "    OOOOO                 '\"OOOOOOOOOOOOOOOO\"`                oOO",
      \ "   oOOOOOba.                .adOOOOOOOOOOba               .adOOOOo.",
      \ "  oOOOOOOOOOOOOOba.    .adOOOOOOOOOO@^OOOOOOOba.     .adOOOOOOOOOOOO",
      \ "  OOOOOOOOOOOOOOOOO.OOOOOOOOOOOOOO\"`  '\"OOOOOOOOOOOOO.OOOOOOOOOOOOOO",
      \ "    :            .oO%OOOOOOOOOOo.OOOOOO.oOOOOOOOOOOOO?         .",
      \ "    Y           'OOOOOOOOOOOOOO: .oOOo. :OOOOOOOOOOO?'         :`",
      \ "    .            oOOP\"%OOOOOOOOoOOOOOOO?oOOOOO?OOOO\"OOo",
      \ "                 '%o  OOOO\"%OOOO%\"%OOOOO\"OOOOOO\"OOO':",
      \ "                      `$\"  `OOOO' `O\"Y ' `OOOO'  o             .",
      \ "    .                  .     OP\"          : o     .",
      \ "",
      \ ]
let g:dashboard_custom_header = [
      \ "The Zen of Python, by Tim Peters",
      \ "",
      \ " - Beautiful is better than ugly.",
      \ " - Explicit is better than implicit.",
      \ " - Simple is better than complex.",
      \ " - Complex is better than complicated.",
      \ " - Flat is better than nested.",
      \ " - Sparse is better than dense.",
      \ " - Readability counts.",
      \ " - Special cases aren't special enough to break the rules.",
      \ " - Although practicality beats purity.",
      \ " - Errors should never pass silently.",
      \ " - Unless explicitly silenced.",
      \ " - In the face of ambiguity, refuse the temptation to guess.",
      \ " - There should be one-- and preferably only one --obvious way to do it.",
      \ " - Although that way may not be obvious at first unless you're Dutch.",
      \ " - Now is better than never.",
      \ " - Although never is often better than *right* now.",
      \ " - If the implementation is hard to explain, it's a bad idea.",
      \ " - If the implementation is easy to explain, it may be a good idea.",
      \ " - Namespaces are one honking great idea -- let's do more of those!",
      \ ]

let g:dashboard_custom_shortcut={
\ 'last_session'       : ', s l',
\ 'find_history'       : ', f h',
\ 'find_file'          : ', f f',
\ 'new_file'           : ', c n',
\ 'change_colorscheme' : ', t c',
\ 'find_word'          : ', f a',
\ 'book_marks'         : ', f b',
\ }

nmap <Leader>ss :<C-u>SessionSave<CR>
nmap <Leader>sl :<C-u>SessionLoad<CR>
nnoremap <silent> <Leader>fh :DashboardFindHistory<CR>
nnoremap <silent> <Leader>ff :DashboardFindFile<CR>
nnoremap <silent> <Leader>tc :DashboardChangeColorscheme<CR>
nnoremap <silent> <Leader>fa :DashboardFindWord<CR>
nnoremap <silent> <Leader>fb :DashboardJumpMark<CR>
nnoremap <silent> <Leader>cn :DashboardNewFile<CR>
