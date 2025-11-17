if not _G.xml_env_set then
    _G.xml_env_set = true
    vim.schedule(function()
        local lsp_cfg = require("config.lsp")
        if lsp_cfg.is_enabled("xml", "lemminx") and vim.fn.executable("lemminx") == 1 then
            vim.lsp.enable("lemminx")
        end
    end)
end

