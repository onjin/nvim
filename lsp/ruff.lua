---@brief
---
--- https://github.com/astral-sh/ruff
---
--- A Language Server Protocol implementation for Ruff, an extremely fast Python linter and code formatter, written in Rust. It can be installed via `pip`.
---
--- ```sh
--- pip install ruff
--- ```
---
--- **Available in Ruff `v0.4.5` in beta and stabilized in Ruff `v0.5.3`.**
---
--- This is the new built-in language server written in Rust. It supports the same feature set as `ruff-lsp`, but with superior performance and no installation required. Note that the `ruff-lsp` server will continue to be maintained until further notice.
---
--- Server settings can be provided via:
---
--- ```lua
--- vim.lsp.config('ruff', {
---   init_options = {
---     settings = {
---       -- Server settings should go here
---     }
---   }
--- })
--- ```
---
--- Refer to the [documentation](https://docs.astral.sh/ruff/editors/) for more details.

---@type vim.lsp.Config
return {
    cmd = { 'ruff', 'server' },
    filetypes = { 'python' },
    root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', '.git' },
    single_file_support = true,
    init_options = {
        settings = {
            organizeImports = true,
            lint = {
                extendSelect = {
                    "A",
                    "ARG",
                    "B",
                    "COM",
                    "C4",
                    "FBT",
                    "I",
                    "ICN",
                    "N",
                    "PERF",
                    "PL",
                    "Q",
                    "RET",
                    "RUF",
                    "SIM",
                    "SLF",
                    "TID",
                    "W",
                },
            },
        },
    },

    on_init = function(client)
        client.offset_encoding = "utf-8"
        client.server_capabilities.hoverProvider = false
    end,
    settings = {},
}
