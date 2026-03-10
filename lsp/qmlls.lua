local lsp_cfg = require("config.lsp")
local server_cfg = lsp_cfg.get("qml", "qmlls")

---@type vim.lsp.Config
return {
    cmd = server_cfg and server_cfg.cmd or { "qmlls", "-E" },
    filetypes = { "qml" },
    root_markers = { ".qmlls.ini", "shell.qml", "qmldir", ".git" },
    single_file_support = true,
}
