# Neovim Config

A focused, batteries-included Neovim configuration built around the `mini.nvim` ecosystem with language server extras and ergonomic defaults. Use this README to get set up quickly and discover the main features.

## Quick Start

1. Back up any existing config: `mv ~/.config/nvim ~/.config/nvim.bak`.
2. Clone this repository: `git clone <repo-url> ~/.config/nvim` (or to `$XDG_CONFIG_HOME/nvim`).
3. Sync plugins headlessly: `nvim --headless "+Lazy! sync" +qa`.
4. Run a health check: `nvim --headless "+checkhealth" +qa`.
5. Launch Neovim normally and open a project to trigger language servers.

## Requirements

- Neovim 0.10+ with LuaJIT (treesitter folding and `vim.lsp.enable` APIs are used).
- Git (`lazy.nvim` bootstraps repositories on demand).
- ripgrep (`mini.pick` live grep and `todo-comments` use it).
- Language servers and formatters: `lua-language-server`, `basedpyright-langserver`, `ruff`, `rust-analyzer`, `nixd`, `nixfmt`, `jdtls` (Rust checks use `cargo clippy`).

## Directory Tour

- **init.lua** – boots editor options, loads the plugin spec, and bootstraps the lazy.nvim manager.
- **lua/config/** – shared options (`options.lua`), terminal helpers, and general utilities.
- **lua/plugins/** – plugin spec (`spec.lua`) and per-plugin configs under `config/`.
- **after/** – post-load hooks: keymaps, autocommands, and filetype-specific tweaks.
- **lsp/** – per-server configurations consumed by `vim.lsp.enable`.

## Core Defaults

- Leader key is `,` and local leader is space for language-specific bindings.
- Four-space indentation, `expandtab`, relative line numbers, and persistent undo.
- `catppuccin-mocha` colorscheme with a dark background and smooth status/tab lines.
- Treesitter-backed folding plus `inccommand=split` for live substitution previews.
- System clipboard integration via `unnamedplus` and mouse-enabled split management.
- Terminal buffers open in insert mode with a `<leader>ot` scratchpad.

## Plugin Highlights

- **Navigation & Search** – `mini.pick`, `mini.extra`, `reach.nvim`, `marks.nvim`, and `oil.nvim` keep buffers, marks, and files within a keystroke.
- **UI & Feedback** – `catppuccin`, `mini.notify`, `nvim-ufo`, and `todo-comments` surface structure, notifications, and folding hints.
- **Coding Aids** – `nvim-cmp` + `cmp-nvim-lsp`, `nvim-treesitter`, `treesitter-context`, and `nvim_context_vt` drive completion and structural awareness.
- **Snippets & Docs** – `mini.snippets`, `friendly-snippets`, and `neogen` accelerate boilerplate, while `markview.nvim`/`markdown-preview.nvim` preview Markdown.
- **Integrations** – `which-key`, `mini.sessions`, `mini.visits`, `mini.git`, `cord.nvim` (Discord presence), and `windsurf.nvim` (Codeium when `ai_enabled` is true) round out productivity.

## Keymaps to Remember

- `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>` move across windows; `<leader>?` shows buffer-local mappings via which-key.
- `<leader>sf`, `<leader>sb`, `<leader>sg`, `<leader>s*` trigger `mini.pick` for files, buffers, live git grep, and word grep.
- `<leader>fk`, `<leader>fc`, `<leader>fs` search keymaps, commands, and spelling suggestions with `mini.extra`.
- `<leader>oo` toggles the `aerial` outline; `<leader>/` invokes a global which-key cheat-sheet.
- `<leader>ot` opens a reusable bottom terminal; hit `<Esc><Esc>` inside terminals to return to normal mode.
- `<leader>tD`, `<leader>td`, `<leader>tm` toggle diagnostics, virtual text, and scrolloff focus.

## Language Servers

- **Auto attach** – `after/ftplugin/*.lua` enables servers (`basedpyright`, `ruff`, `rust_analyzer`, `lua_ls`, `nixd`, `jdtls`) whenever the corresponding filetype loads and the executable exists.
- **Install tips** – use your package manager or `pip` for `basedpyright-langserver` and `ruff`, Nix flakes for `nixd`/`nixfmt`, and `jdtls` with Lombok support (set `$JDTLS_LOMBOK` or `$LOMBOK_JAR`).
- **Rust** – uses `rust-analyzer`; if it is missing on NixOS, add `pkgs.rust-analyzer` to your flake/devShell packages or run `nix profile install nixpkgs#rust-analyzer` for a user install. `cargo clippy` powers the default check command.
- **Commands** – `:LspAttach`, `:LspDettach`, `:LspRestart`, `:LspInfo`, and `:LspLog` manage clients; attach/detach commands use picker UIs.
- **Formatting** – `ruff` formats Python on save, and a fallback format-on-save autocmd is injected when servers advertise `textDocument/formatting`.
- **Customizing** – tweak per-server settings in `lsp/*.lua`; these tables are consumed directly by `vim.lsp.enable`.

## Treesitter & Syntax

- Automatic parser installation with `ensure_installed` for Lua, Vimdoc, Python, Java, and Bash.
- Treesitter folding is enabled by default; disable per buffer with `:set nofoldenable` if needed.
- `treesitter-context` pins the current function/class at the top of the window with optional virtual text via `nvim_context_vt`.
- Highlighted TODO/FIX/etc comments come from `todo-comments` with ripgrep-backed search.

## Terminal & Tools

- Terminals open in insert mode and can be spawned quickly with `<leader>ot`.
- `Snacks.picker` replaces `vim.ui.select` globally, providing consistent fuzzy UIs for LSP pickers and user commands.
- Diagnostics helpers (`<leader>dl`, `<leader>dL`, `<leader>e`) rely on Snacks pickers to surface issues by scope.

## Plugin Management & Updates

- `init.lua` bootstraps `lazy.nvim` automatically and then loads `lua/plugins/spec.lua`.
- Keep plugin-specific settings in `lua/plugins/config/`; shared helpers live under `lua/config/`.
- Run `nvim --headless "+Lazy! sync" +qa` (or `:Lazy sync` interactively) whenever you change the spec.
- `lazy-lock.json` pins plugin commits; commit it alongside spec changes so checkouts stay reproducible.

## Maintenance & Troubleshooting

- Run `nvim --headless "+checkhealth" +qa` after adding plugins or language servers to confirm integrations.
- Set `NVIM_LOG_LEVEL=DEBUG` before launching Neovim to enable verbose logging through `lua/utils.lua`.
- Use `:messages` and `:LspLog` to inspect errors; most plugin setups emit log lines via `utils.log_*`.
- If a plugin misbehaves, temporarily disable it in `lua/plugins/spec.lua`, run `:Lazy sync`, and restart Neovim.

## Per-project Overrides & Help

- Drop a `.nvimrc.ini` file in your project root to override globals (e.g., `ai_enabled`, `autoformat_on_save_enabled`, `colorscheme`). Use `:NVRCEdit`, `:NVRCApply`, and `:NVRCVariables` to manage overrides without restarting Neovim.
- `:help onjin` loads the generated help doc from `doc/onjin.txt`. Regenerate it after README edits with `panvimdoc --project-name onjin --input-file doc/onjin.md --output-file doc/onjin.txt`.
- After regenerating `doc/onjin.txt`, run `:helptags ~/.config/nvim/doc` (or `:helptags ALL`) so Neovim updates its help index and `:help onjin` resolves correctly.

Happy hacking!
