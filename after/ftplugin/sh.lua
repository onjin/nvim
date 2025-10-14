_G.shell_env_set = _G.shell_env_set or (function()
    if vim.fn.executable("bash-language-server") == 1 then
        vim.lsp.enable("bashls")
    end
    return true
end)()
