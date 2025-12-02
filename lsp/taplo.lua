local lsp_cfg = require("config.lsp")
local server_cfg = lsp_cfg.get("toml", "taplo")

---@type vim.lsp.Config
return {
    cmd = { "taplo", "lsp", "stdio" },
    filetypes = { "toml" },
    root_markers = { "Cargo.toml", "pyproject.toml", "taplo.toml", ".taplo.toml", ".git" },
    single_file_support = true,
    settings = server_cfg and vim.deepcopy(server_cfg.settings) or nil,
}

