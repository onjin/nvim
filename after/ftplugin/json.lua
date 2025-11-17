if not _G.json_env_set then
    _G.json_env_set = true
    vim.schedule(function()
        local lsp_cfg = require("config.lsp")
        if lsp_cfg.is_enabled("json", "jsonls") and vim.fn.executable("vscode-json-language-server") == 1 then
            vim.lsp.enable("jsonls")
        end
    end)
end

