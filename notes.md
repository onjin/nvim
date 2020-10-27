# notes

## profiling

```
:profile start profile.log
:profile func *
:profile file *
" At this point do slow actions
:profile pause
:noautocmd qall!
```

## dump all keybindings

```
:redir! > vim_keys.txt
:silent verbose map
:redir END
```
