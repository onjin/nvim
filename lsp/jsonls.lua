local lsp_cfg = require("config.lsp")
local server_cfg = lsp_cfg.get("json", "jsonls")

---@type vim.lsp.Config
return {
    cmd = { "vscode-json-language-server", "--stdio" },
    filetypes = { "json", "jsonc" },
    root_markers = { ".git" },
    init_options = {
        provideFormatter = true,
    },
    settings = server_cfg and vim.deepcopy(server_cfg.settings) or {
        json = {
            validate = { enable = true },
            format = { enable = true },
        },
    },
}

