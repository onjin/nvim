# Personal `neovim` configuration.

Mostly used for DevOps and Python (web) development.
black
#112233
#000000
#ff0000

In neovim help:
```
:help onjin
```

## Features

- Plugins manager — https://github.com/folke/lazy.nvim
- Support for `.editorconfig` — https://github.com/editorconfig/editorconfig-vim
- Fuzzy search engine https://github.com/nvim-telescope/telescope.nvim
- Intellisense engine https://github.com/neovim/nvim-lspconfig + https://github.com/williamboman/mason-lspconfig.nvim
- AI support https://github.com/jcdickinson/codeium.nvim - free code assistance https://codeium.com/pricing (set .nvimrc.ini or vim.g.ai_enabled directly to enable)
- Displays available keybindings in popup — https://github.com/folke/which-key.nvim

For a full list of plugins refer to https://github.com/onjin/.vim/blob/main/lua/custom/plugins/

## Local .nvimrc.ini config for global variables

By creating `.nvimrc.ini` file in your project folder you can set global variables.

```dosini
;enable AI codeium
ai_enabled = 1

;enable autoformat on save
autoformat_on_save_enabled = 1

; set leader key
mapleader = ' '
```

## Screenshots

Which key keybindings popup, just press `,` and wait for help

![Screenshot](https://github.com/onjin/nvim/assets/44516/a689b08b-632d-47f9-ba14-a69afa84aac5)

LSP support

![Screenshot](https://github.com/onjin/nvim/assets/44516/00d7de32-539a-435f-8acd-c98a6b185d31)

Markdown live preview

![Screenshot](https://github.com/onjin/nvim/assets/44516/0678cc18-c93d-483d-a1dd-5d7213190efe)

## Install by `git`

Make sure you move old `~/.vim` to f.i. `~/.vim.old` then you can go

**Requirements**: some plugins require `rust` already installed (f.e. `blam`).

```
git clone https://github.com/onjin/nvim ~/.config/nvim
```

Plugins should be installed at first run of editor. If not, then run `:Lazy` to do it manually.


Discover shortcuts:

- `,` or `<space>` to get help for leader keys from `which-key`

## Requirements for python

- pynvim

```
pip install pynvim
```

## Nice to have

- Nerd Icons - https://www.nerdfonts.com/

