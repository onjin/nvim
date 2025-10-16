local lsp_cfg = require("config.lsp")
local server_cfg = lsp_cfg.get("python", "basedpyright")

return {
    cmd = { "basedpyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "settings.py", ".git" },
    on_init = function(client)
        client.offset_encoding = "utf-8"
    end,
    on_attach = function(_) end,
    single_file_support = true,
    settings = server_cfg and vim.deepcopy(server_cfg.settings) or nil,
}
