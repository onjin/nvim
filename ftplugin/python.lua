vim.lsp.config("ty", {
	cmd = { "uvx", "ty" },
})

vim.lsp.enable("ty")

vim.lsp.config("ruff", {
	cmd = { "uvx", "ruff" },
})
vim.lsp.enable("ruff")
