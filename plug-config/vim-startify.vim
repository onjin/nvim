let g:startify_custom_header = startify#pad(split(system('gh pr status'), '\n'))

function! StartifyEntryFormat()
    return 'WebDevIconsGetFileTypeSymbol(absolute_path) ." ". entry_path'
endfunction
  function! s:list_commits()
    let git = 'git -C .'
    let commits = systemlist(git .' log --pretty=format:"%C(yellow)%h %Cred%ad %Cblue%an%Cgreen%d %Creset%s" --date=iso --no-merges -10')
    let git = 'G'. git[1:]
    return map(commits, '{"line": matchstr(v:val, "\\s\\zs.*"), "cmd": "'. git .' show ". matchstr(v:val, "^\\x\\+") }')
  endfunction

  let g:startify_lists = [
        \ { 'header': ['   MRU '. getcwd()], 'type': 'dir' },
        \ { 'header': ['   Sessions'],       'type': 'sessions' },
        \ { 'header': ['   Commits'],        'type': function('s:list_commits') },
        \ { 'header': ['   MRU'],            'type': 'files' },
        \ ]
