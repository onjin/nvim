if not _G.lua_env_set then
    _G.lua_env_set = true
    vim.schedule(function()
        local lsp_cfg = require("config.lsp")
        if lsp_cfg.is_enabled("lua", "lua_ls") then
            vim.lsp.enable("lua_ls")
        end
    end)
end
