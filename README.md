# Personal `vim` and `neovim` configuration.

Mostly used for DevOps and Python (web) development.

## Features

 * Plugins manager — https://github.com/junegunn/vim-plug
 * Support for `.editorconfig` — https://github.com/editorconfig/editorconfig-vim
 * Fuzzy search engines:
	* https://github.com/nvim-telescope/telescope.nvim -> (let $FUZZY_FINDER='telescope') [default]
	* https://github.com/junegunn/fzf.vim -> (let $FUZZY_FINDER='fzf')
 * Intellisense engines:
	*	https://github.com/neovim/nvim-lspconfig ->  (let $LSP='native') [default]
	* https://github.com/neoclide/coc.nvim -> (let $LSP='coc') 
 * Autoresize windows — https://github.com/camspiers/lens.vim
 * Live Markdown preview with diagrams support — https://github.com/iamcco/markdown-preview.nvim
 * Displays available keybindings in popup — https://github.com/liuchengxu/vim-which-key

For a full list of plugins refer to https://github.com/onjin/.vim/blob/main/vim-plug/plugins.vim

## Screenshots

Which key keybindings popup, just press `,` and wait for help

![Screenshot](https://user-images.githubusercontent.com/44516/162916448-0d41d3e6-96e2-4ab4-92f0-6e4f7fcc1f8c.png)


LSP support

![Screenshot](https://user-images.githubusercontent.com/44516/162918787-1c788b22-51db-4c9a-888a-f5cfc4abcc79.png)

Markdown live preview

![Screenshot](https://user-images.githubusercontent.com/44516/162917974-f36a192c-3347-476d-91e0-e22f2e1bf916.png)

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


