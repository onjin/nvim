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

## Quickstart

### Single-file `init_compact.lua`

You can use the generated single-file config without cloning the whole repo.

Save it as your main config:

```bash
curl -fsSL https://raw.githubusercontent.com/onjin/nvim/main/init_compact.lua -o ~/.config/nvim/init.lua
```

Or run Neovim directly with it from any path:

```bash
curl -fsSL https://raw.githubusercontent.com/onjin/nvim/main/init_compact.lua -o /tmp/init_compact.lua
nvim -u /tmp/init_compact.lua
```

### Run directly with Nix

Run this config without cloning the repo or writing it into `~/.config/nvim`:

```bash
nix run github:onjin/nvim
```

By default this launcher uses its own isolated base directory at `~/.local/share/onjin-nvim`.
That means it writes to:

- `~/.local/share/onjin-nvim/config`
- `~/.local/share/onjin-nvim/data`
- `~/.local/share/onjin-nvim/state`
- `~/.local/share/onjin-nvim/cache`
- `~/.local/share/onjin-nvim/tree-sitter-parsers`

This also keeps the `tree-sitter` CLI config under the same isolated root, so it does not depend on `~/.config/tree-sitter/config.json`.

To use a different base directory, override it explicitly:

```bash
ONJIN_NVIM_HOME=/tmp/onjin-nvim nix run github:onjin/nvim
```



## Install

Clone this repo to:

```bash
~/.config/nvim
```

Then start Neovim. Plugins are declared in `init.lua` and `lua/plugins/*.lua`.

To generate a self-contained single-file version of this config, run:

```bash
./compact.sh
```

This creates `init_compact.lua`, which bundles local modules from `lua/` and runtime files such as `plugin/` and `ftplugin/`.

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
- in insert mode:
    - `<C-x><C-u>` opens generated values completion (`uuid1-7`, `ulid`, date/time)
    - `<C-g>k` opens generated values menu (`vim.ui.select`)
    - `<C-x>1..7` inserts `uuid1..uuid7`
    - `<C-x>u` inserts `ulid`
    - `<C-x>d` inserts date (`YYYY-MM-DD`)
    - `<C-x>t` inserts datetime (`YYYY-MM-DD HH:MM:SS`)
    - `<C-x>i` inserts ISO datetime (`YYYY-MM-DDTHH:MM:SS+TZ:TZ`)
- `TSInsall [python]` - to install required tree sitter queries for certain languages

## Included

- `snacks.nvim` for pickers and toggles
- `quicker.nvim` for editable `quickfix` window as buffer
- `oil.nvim` for directory editing as buffer
- native LSP with Lua, Bash, Java, and Python support
- `conform.nvim` for formatting
- Treesitter, Catppuccin, mini status/tab line, and todo highlighting

### Test in isolation

Run the compact config with isolated `XDG_*` directories:

```bash
./test-compact.sh
```

Run the local flake the same way:

```bash
./test-flake.sh
```

Both scripts avoid loading `~/.config/nvim`. On the first run they may still need network access, because `vim.pack` installs plugins into isolated `XDG_DATA_HOME`.
