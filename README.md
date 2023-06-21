# Personal `neovim` configuration.

Mostly used for DevOps and Python (web) development.

In neovim help:
```
:help onjin
```

## Features

- Plugins manager — https://github.com/folke/lazy.nvim
- Support for `.editorconfig` — https://github.com/editorconfig/editorconfig-vim
- Fuzzy search engine https://github.com/nvim-telescope/telescope.nvim
- Intellisense engine https://github.com/neovim/nvim-lspconfig + https://github.com/williamboman/mason-lspconfig.nvim
- AI support https://github.com/jcdickinson/codeium.nvim - free code assistance https://codeium.com/pricing
- Displays available keybindings in popup — https://github.com/liuchengxu/vim-which-key

For a full list of plugins refer to https://github.com/onjin/.vim/blob/main/lua/plugins/init.lua

## Screenshots
Simple dashboard

![Screenshot](https://github.com/onjin/nvim/assets/44516/1bb97e31-b452-49c7-b2ac-ed2bf7183877)

Which key keybindings popup, just press `,` and wait for help

![Screenshot](https://user-images.githubusercontent.com/44516/162916448-0d41d3e6-96e2-4ab4-92f0-6e4f7fcc1f8c.png)

LSP support

![Screenshot](https://user-images.githubusercontent.com/44516/162918787-1c788b22-51db-4c9a-888a-f5cfc4abcc79.png)

Markdown live preview

![Screenshot](https://user-images.githubusercontent.com/44516/162917974-f36a192c-3347-476d-91e0-e22f2e1bf916.png)

## Install by `git`

Make sure you move old `~/.vim` to f.i. `~/.vim.old` then you can go

**Requirements**: some plugins require `rust` already installed (f.e. `blam`).

```
git clone https://github.com/onjin/nvim ~/.config/nvim
```

Plugins should be installed at first run of editor. If not, then run `:Lazy` to do it manually.

## Daily usage

Configuration:
- edit `lua/onjin/config.lua`

Discover shortcuts:

- `,hK` - display all keybindings [help keybindings]
- `,` or `<space>` to get help for leader keys from `which-key`
- `<ctrl-p>` - to get available all commands registered which `which-key` displayed by `legendary.vim`

Common shortcuts:

- `<ctrl-[hjkl]>` - to move cursor between splits and/or tmux splits (look integration doc below)
- `,ff` - fuzzy search files for current directory [find files]
- `,fg` - fuzzy search GIT files for current (or searched for `.git` upward) directory [find git]
- `,bX` - to open buffer's management menu, or `,bx` to just close current buffer [buffer 'X'] [buffer 'x']
- `,wz` - toogle `zoom` for current buffer [window zoom]

- `,ld` - show current line diagnostics in popup [lsp diagnostic]
- `,dl` - quick load all diagnostics messages in `loclist` [diagnostics loclist]
- `,lm` - format current buffer using LSP [lsp format]
- `,la` - show code action selector, `q` to close [lsp action]
- `,lR` - open rename action selector [lsp rename]
- `gd` - goto current symbol definition, `<ctrl-o>` to get back, and back and back, ...
- `gp` - peek definition in popup window, `q` to close it
- `K` - show symbol's docstring in popup window, move cursor to exit

Update:

- `:Lazy` to install/update/clean plugins
- `:Mason` to install/update/clean LSP servers/formatters/DAPs/linters

Syntax highlighting:

- `TSInstallInfo` - display info about installed/available TreeSitter syntax
- `TSInstall <name>` - install TreeSitter syntax

## Integrations

**tmux**:

Add these lines to `tmux` to move around vim/tmux splits with same shortcuts

```ini
# smart pane switching with awareness of vim splits
bind -n C-h run "(tmux display-message -p '#{pane_current_command}' | grep -iq vim && tmux send-keys C-h) || tmux select-pane -L"
bind -n C-j run "(tmux display-message -p '#{pane_current_command}' | grep -iq vim && tmux send-keys C-j) || tmux select-pane -D"
bind -n C-k run "(tmux display-message -p '#{pane_current_command}' | grep -iq vim && tmux send-keys C-k) || tmux select-pane -U"
bind -n C-l run "(tmux display-message -p '#{pane_current_command}' | grep -iq vim && tmux send-keys C-l) || tmux select-pane -R"
bind -n C-\\ run "(tmux display-message -p '#{pane_current_command}' | grep -iq vim && tmux send-keys 'C-\\') || tmux select-pane -l"

```

## Requirements for python

- pynvim

```
pip install pynvim
```

## Nice to have

- Nerd Icons - https://www.nerdfonts.com/

