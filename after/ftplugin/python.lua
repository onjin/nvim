if not _G.python_env_set then
    _G.python_env_set = true
    vim.schedule(function()
        if vim.fn.executable("basedpyright-langserver") == 1 then
            vim.lsp.enable("basedpyright")
        end
        if vim.fn.executable("ruff") == 1 then
            vim.lsp.enable("ruff")
        end
    end)
end
