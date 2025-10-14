if not _G.nix_env_set then
    _G.nix_env_set = true
    vim.schedule(function()
        if vim.fn.executable("nixd") == 1 then
            vim.lsp.enable("nixd")
        end
    end)
end
