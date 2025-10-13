if vim.fn.executable("nixd") == 1 then
    vim.lsp.enable("nixd")
end
