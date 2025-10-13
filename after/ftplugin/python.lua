_G.python_env_set = _G.python_env_set
    or (function()
        if vim.fn.executable("basedpyright-langserver") == 1 then
            vim.lsp.enable("basedpyright")
        end

        if vim.fn.executable("ruff") == 1 then
            vim.lsp.enable("ruff")
        end
        return true
    end)()
