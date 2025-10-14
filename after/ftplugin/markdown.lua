if not _G.markdown_env_set then
    _G.markdown_env_set = true
    vim.schedule(function()
        local lsp_cfg = require("config.lsp")
        if lsp_cfg.is_enabled("markdown", "marksman") and vim.fn.executable("marksman") == 1 then
            vim.lsp.enable("marksman")
        end
    end)
end
