if not _G.cpp_env_set then
    _G.cpp_env_set = true
    vim.schedule(function()
        vim.lsp.enable('clangd')
    end)
end
