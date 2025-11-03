vim.opt_local.expandtab = false
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.tabstop = 4

if not _G.go_env_set then
    _G.go_env_set = true
    vim.schedule(function()
        vim.lsp.enable("gopls")
    end)
end
