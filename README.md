# Neovim Config

A focused, batteries-included Neovim configuration built around the `mini.nvim` ecosystem with language server extras and ergonomic defaults. Use this README to get set up quickly and discover the main features.

## Quick Start

1. Back up any existing config: `mv ~/.config/nvim ~/.config/nvim.bak`.
2. Clone this repository: `git clone <repo-url> ~/.config/nvim` (or to `$XDG_CONFIG_HOME/nvim`).
3. Sync plugins headlessly: `nvim --headless "+lua require('plugins.engine').execute('mini-deps', require('plugins.spec'))" +qa`.
4. Run a health check: `nvim --headless "+checkhealth" +qa`.
5. Launch Neovim normally and open a project to trigger language servers.

## Requirements

- Neovim 0.10+ with LuaJIT (treesitter folding and `vim.lsp.enable` APIs are used).
- Git (plugin engine bootstraps repositories on demand).
- ripgrep (`mini.pick` live grep and `todo-comments` use it).
- Language servers and formatters: `lua-language-server`, `basedpyright-langserver`, `ruff`, `nixd`, `nixfmt`, `jdtls`.

## Directory Tour

- **init.lua** – boots editor options, loads the plugin spec, and chooses the plugin engine.
- **lua/config/** – shared options (`options.lua`), terminal helpers, and general utilities.
- **lua/plugins/** – plugin spec (`spec.lua`), the engine abstraction, and per-plugin configs under `config/`.
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

- **Navigation & Search** – `mini.pick` replaces Telescope, `mini.extra` adds pickers, `oil.nvim` provides an in-buffer file manager.
- **UI & Feedback** – `catppuccin`, `mini.notify`, and `todo-comments` surface visual cues and notifications.
- **Coding Aids** – `nvim-treesitter`, `treesitter-context`, `nvim_context_vt`, and `harpoon` keep structure visible and files at hand.
- **Snippets & Docs** – `mini.snippets`, `friendly-snippets`, and `neogen` speed up boilerplate and documentation.
- **Productivity** – `which-key`, `mini.sessions`, `mini.visits`, and `mini.git` streamline discovery, session handling, and lightweight git status.

## Keymaps to Remember

- `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>` move across windows; `<leader>?` shows buffer-local mappings via which-key.
- `<leader>sf`, `<leader>sb`, `<leader>sg`, `<leader>s*` trigger `mini.pick` for files, buffers, live git grep, and word grep.
- `<leader>fk`, `<leader>fc`, `<leader>fs` search keymaps, commands, and spelling suggestions with `mini.extra`.
- `<leader>oo` toggles the `aerial` outline; `<leader>/` invokes a global which-key cheat-sheet.
- `<leader>ot` opens a reusable bottom terminal; hit `<Esc><Esc>` inside terminals to return to normal mode.
- `<leader>tD`, `<leader>td`, `<leader>tm` toggle diagnostics, virtual text, and scrolloff focus.

## Language Servers

- **Auto attach** – `after/ftplugin/*.lua` enables servers (`basedpyright`, `ruff`, `lua_ls`, `nixd`, `jdtls`) whenever the corresponding filetype loads and the executable exists.
- **Install tips** – use your package manager or `pip` for `basedpyright-langserver` and `ruff`, Nix flakes for `nixd`/`nixfmt`, and `jdtls` with Lombok support (set `$JDTLS_LOMBOK` or `$LOMBOK_JAR`).
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
- `MiniPick` replaces `vim.ui.select` globally, providing consistent fuzzy UIs for LSP pickers and user commands.
- Harpoon’s quick menu (`<M-h><M-l>`) and slots (`<space>1`…`<space>5`) keep hot files one keystroke away.
- Diagnostics helpers (`<leader>dl`, `<leader>dL`, `<leader>e`) rely on mini pickers to surface issues by scope.

## Plugin Management & Updates

- `init.lua` now defaults to the `lazy.nvim` engine; pass `"mini-deps"` to `engine.execute` when you want MiniDeps to drive installs without the lazy UI.
- Add or adjust plugins via `lua/plugins/spec.lua`; per-plugin settings live in `lua/plugins/config/`.
- The `minis_enabled` table toggles bundled mini modules—remove entries to slim down features.
- Run `nvim --headless "+lua require('plugins.engine').execute('mini-deps', require('plugins.spec'))" +qa` after edits to the spec to sync repositories.
- When using MiniDeps, pins honour `branch`, `tag`, and `commit` fields; unsupported lazy-only triggers emit warnings at startup.

## Maintenance & Troubleshooting

- Run `nvim --headless "+checkhealth" +qa` after adding plugins or language servers to confirm integrations.
- Set `NVIM_LOG_LEVEL=DEBUG` before launching Neovim to enable verbose logging through `lua/utils.lua`.
- Use `:messages` and `:LspLog` to inspect errors; most plugin setups emit log lines via `utils.log_*`.
- If a plugin misbehaves, temporarily disable it in `lua/plugins/spec.lua` or remove its entry from `minis_enabled` and resync.

Happy hacking!
