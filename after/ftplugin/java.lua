if not _G.java_env_set then
    _G.java_env_set = true
    vim.schedule(function()
        vim.lsp.enable("jdtls")
    end)
end
