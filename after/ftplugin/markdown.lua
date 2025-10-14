if not _G.markdown_env_set then
    _G.markdown_env_set = true
    vim.schedule(function()
        if vim.fn.executable("marksman") == 1 then
            vim.lsp.enable("marksman")
        end
    end)
end
