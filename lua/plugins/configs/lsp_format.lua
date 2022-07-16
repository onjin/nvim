local present, lsp_format = pcall(require, "lsp-format")

if not present then
	return
end
local prettier = {
	tabWidth = 4,
	singleQuote = true,
	trailingComma = "all",
	configPrecedence = "prefer-file",
}
local options = {
	typescript = prettier,
	javascript = prettier,
	typescriptreact = prettier,
	javascriptreact = prettier,
	json = prettier,
	css = prettier,
	scss = prettier,
	html = prettier,
	yaml = {
		tabWidth = 2,
		singleQuote = true,
		trailingComma = "all",
		configPrecedence = "prefer-file",
	},
	markdown = prettier,
	sh = {
		tabWidth = 4,
	},
}

options = require("core.utils").load_override(options, "lukas-reineke/lsp-format.nvim")
lsp_format.setup(options)
