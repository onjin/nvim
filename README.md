# Neovim Config

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
- `<leader>sf` search files
- `<leader>sg` live grep in git-tracked files
- `<leader>sG` live grep with `rg`
- `glf` format the current buffer
- `grd` jump to definition
- `<leader>?` shows buffer-local keymaps

## Included

- `snacks.nvim` for pickers and toggles
- `oil.nvim` for directory editing
- native LSP with Lua, Bash, Java, and Python support
- `conform.nvim` for formatting
- Treesitter, Catppuccin, mini status/tab line, and todo highlighting
