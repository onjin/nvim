# Personal `vim` and `neovim` configuration.

Mostly used for DevOps and Python (web) development.

## Features

 * Plugins manager — https://github.com/junegunn/vim-plug
 * Support for `.editorconfig` — https://github.com/editorconfig/editorconfig-vim
 * Fuzzy search engine — https://github.com/junegunn/fzf.vim
 * Intelissense engine — https://github.com/neoclide/coc.nvim
 * Autoresize windows — https://github.com/camspiers/lens.vim
 * Live Markdown preview with diagrams support — https://github.com/iamcco/markdown-preview.nvim
 * Displays available keybindings in popup — https://github.com/liuchengxu/vim-which-key

For a full list of plugins reffer to https://github.com/onjin/.vim/blob/main/vim-plug/plugins.vim

## Screenshots

Which key keybindings popup, just press `,` and wait for help

![Screenshot](https://user-images.githubusercontent.com/44516/95565033-e65c3a80-0a1f-11eb-9cb4-8cfca2ad4fef.png)

Markdown live preview

![image](https://user-images.githubusercontent.com/44516/95565256-31764d80-0a20-11eb-8216-7c2dc85b7fe8.png)

## Install by `git`

Make sure you move old `~/.vim` to f.i. `~/.vim.old` then you can go

```
git clone https://github.com/onjin/.vim ~/.vim
```

Plugins should be installed at first run of editor. If not, then run `:PlugInstall` to do it manually.


## Requirements for `nvim`

* pynvim
```
pip install pynvim
```

 * `ag` - silver search for fzf/codesearch https://github.com/ggreer/the_silver_searcher

## Nice to have
* Nerd Icons - https://www.nerdfonts.com/


