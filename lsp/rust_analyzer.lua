local lsp_cfg = require("config.lsp")
local server_cfg = lsp_cfg.get("rust", "rust_analyzer")

return {
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    root_markers = { "Cargo.toml", "rust-project.json", ".git" },
    settings = server_cfg and vim.deepcopy(server_cfg.settings) or nil,
}
