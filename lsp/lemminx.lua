local lsp_cfg = require("config.lsp")
local server_cfg = lsp_cfg.get("xml", "lemminx")

---@type vim.lsp.Config
return {
    cmd = { "lemminx" },
    filetypes = { "xml", "xsd", "xsl", "xslt", "svg" },
    root_markers = { ".git" },
    single_file_support = true,
    settings = server_cfg and vim.deepcopy(server_cfg.settings) or nil,
}

