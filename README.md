# Neovim Config

> [!TIP]
This is a `neovim 0.12` setup, the previous <0.12 version is at the https://github.com/onjin/nvim/tree/0.11.
To switch previous `main` into the newest run:
```bash
$ git reset --hard origin/main
```

<img width="1888" height="1069" alt="Image" src="https://github.com/user-attachments/assets/693034f4-e4b8-47cb-ba7b-258cf792bc05" />

Small personal Neovim setup built around native `vim.pack`, LSP, fast search, and simple file navigation.

## Requirements

- Neovim with `vim.pack`
- `git`
- `rg`
- formatters you want to use: `stylua`, `prettier`, `black`, `air`
- optional LSP tools: `lua-language-server`, `bash-language-server`, `uvx ty`, `uvx ruff`

## Install

Clone this repo to:

```bash
~/.config/nvim
```

Then start Neovim. Plugins are declared in `init.lua` and `plugin/*.lua`.

## Daily Use

- `,` is the leader key
- `-` opens the file explorer (`oil.nvim`)
- `<leader>s` - prefix for file search, i.e.:
    - `<leader>sf` search files
    - `<leader>sg` live grep in git-tracked files
    - `<leader>sG` live grep with `rg`
- `<leader>f` - prefix for finders, i.e.:
    - `<leader>fk` - find keymaps
- `<leader>t` - prefix for toggles, i.e.:
    - `<leader>ta` - toggle `vim.opt.autocomplete`; default `off` just use `<ctrl-x><ctrl-o>` and friends
    - `<leader>tb` - toggle light/dark theme
- `<leader>g` - prefix Git/GH CLI pickers, i.e.:
    - `<leader>gi` - gh issue list
    - `<leader>gp` - gh pr list
    - `<leader>gs` - git status
- `glf` format the current buffer
- `grd` jump to definition
- `<leader>?` shows buffer-local keymaps
- `TSInsall [python]` - to install required tree sitter queries for certain languages

## Included

- `snacks.nvim` for pickers and toggles
- `quicker.nvim` for editable `quickfix` window as buffer
- `oil.nvim` for directory editing as buffer
- native LSP with Lua, Bash, Java, and Python support
- `conform.nvim` for formatting
- Treesitter, Catppuccin, mini status/tab line, and todo highlighting
