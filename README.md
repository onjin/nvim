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
- Displays available keybindings in popup — https://github.com/folke/which-key.nvim

For a full list of plugins refer to https://github.com/onjin/.vim/blob/main/lua/plugins/

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

## Mappings

- `<ctrl-[hjkl]>` - to move cursor between splits and/or tmux splits (look integration doc below)

+Buffers:
- `tab` - next buffer
- `shift+tab` - previous buffer
- `,b` - buffers submenu
- `,b/` - buffer picker by fuzzy search filename
- `,bc` - close unpinned buffers (use toggle `,tp` to toggle pin)
- `,bn` - create new buffer
- `,bx` - close current buffer
- `,bX` - open buffers closing menu

+Diagnostics:
- `,d` - diagnostics submenu
- `,ds` - show diagnostics messages
- `,dh` - hide diagnostics messages
- `,dd` - disable diagnostics messages
- `,de` - enable diagnostics messages
- `,dl` - load diagnostics messages to `loclist`
- `[d` - jump to previous diagnostic location
- `d]` - jump to next diagnostic location

+Files:
- `,f` - files submenu
- `,f/`, `,ff` - find not hidden files
- `,fa` - find also hidden files
- `,fb` - run file/directories browser
- `,fh` - find help tags
- `,fo` - find old files
- `,fr` - find within files (live grep)
- `,fs` - find saved sessins

+Files +Git:
- `,fg` - git files submenu
- `,fg/`, `,fgf` - find git files
- `,fgb` - find git branches
- `,fgc` - find git commits
- `,fgo` - find git buffer commits
- `,fgs` - find git status
- `,fgt` - find git stash

+Files +Workspaces
- `,fw` - workspaces submenu
- `,fwa` - add workspace folder
- `,fwl` - list workspace folders
- `,fwr` - remove workspace folder

+Help
- `,h` - help menu
- `,hK` - display all mappings using `which-key`
- `,hk` - find and use mapping
- `,hm` - show mappings with fuzzy search
- `,hla` - choose auto commands using `legendary.vim`
- `,hlc` - choose commands using `legendary.vim`
- `,hlf` - choose functions using `legendary.vim`
- `,hlk` - choose keymaps using `legendary.vim`

+Jump
- `,j` - jump menu
- ...

+LSP
- `,l` - LSP menu
- ...

+Projects/Packages
- `,p` - Projects/Packages
- ...

+Registers
- `,r` - Registers menu
- ...

+Spelling
- `,s` - Spelling menu
- ...

+Toggles
- `,t` - Toggles menu
- ...

+UI Toggles/Themes
- `,T` - UI Toggles/Themes menu
- ...

+Utils
- `,u` - Utils menu
- ...

+Windows
- `,u` - Windows menu
- ...

Context mappings using `SPC`

Cargo:
- `SPC c`

GitSigns:
- `SPC g`

NeoTest (in split):
- `SPC T`

NeoTest (in background):
- `SPC t`

## Syntax highlighting

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

