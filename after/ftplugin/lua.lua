if not _G.lua_env_set then
    _G.lua_env_set = true
    vim.schedule(function()
        vim.lsp.enable("lua_ls")
    end)
end
