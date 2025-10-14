if not _G.shell_env_set then
    _G.shell_env_set = true
    vim.schedule(function()
        local lsp_cfg = require("config.lsp")
        if lsp_cfg.is_enabled("sh", "bashls") and vim.fn.executable("bash-language-server") == 1 then
            vim.lsp.enable("bashls")
        end
    end)
end
