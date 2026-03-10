local utils = require("utils")

if not _G.qml_env_set then
    _G.qml_env_set = true
    vim.schedule(function()
        local lsp_cfg = require("config.lsp")
        local enabled = lsp_cfg.is_enabled("qml", "qmlls")
        local has_server = vim.fn.executable("qmlls") == 1

        if enabled and has_server then
            vim.lsp.enable("qmlls")
        elseif enabled then
            utils.log_warn(table.concat({
                "qmlls is not available in PATH.",
                "Install the Qt QML language server and create a `.qmlls.ini` next to `shell.qml`",
                "so Quickshell can manage the import paths for the project.",
            }, "\n"), { title = "QML LSP" })
        end
    end)
end
