local present, lspconfig = pcall(require, "lspconfig")

if not present then
	return
end

-- require("base46").load_highlight "lsp"
-- require "nvchad_ui.lsp"

local M = {}
local utils = require("core.utils")

M.on_attach = function(client, bufnr)
	require("lsp-format").on_attach(client)

	local lsp_mappings = utils.load_config().mappings.lspconfig
	utils.load_mappings({ lsp_mappings }, { buffer = bufnr })
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.completion.completionItem = {
	documentationFormat = { "markdown", "plaintext" },
	snippetSupport = true,
	preselectSupport = true,
	insertReplaceSupport = true,
	labelDetailsSupport = true,
	deprecatedSupport = true,
	commitCharactersSupport = true,
	tagSupport = { valueSet = { 1 } },
	resolveSupport = {
		properties = {
			"documentation",
			"detail",
			"additionalTextEdits",
		},
	},
}

lspconfig.sumneko_lua.setup({
	on_attach = M.on_attach,
	capabilities = capabilities,

	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
				},
				maxPreload = 100000,
				preloadFileSize = 10000,
			},
		},
	},
})

lspconfig.pyright.setup({
	on_attach = M.on_attach,
	capabilities = capabilities,
})

-- thanks to https://github.com/lukas-reineke/dotfiles/blob/6a407f32a73fe8233688e6abfcf366fe5c5c7125/vim/lua/lsp/init.lua
local black = require("efm/black")
local eslint = require("efm/eslint")
local flake8 = require("efm/flake8")
local goimports = require("efm/goimports")
local go_vet = require("efm/go_vet")
local isort = require("efm/isort")
local luacheck = require("efm/luacheck")
local misspell = require("efm/misspell")
local mypy = require("efm/mypy")
local opa = require("efm/opa")
local prettier = require("efm/prettier")
local shellcheck = require("efm/shellcheck")
local shfmt = require("efm/shfmt")
local staticcheck = require("efm/staticcheck")
local stylua = require("efm/stylua")
local terraform = require("efm/terraform")
local vint = require("efm/vint")

lspconfig.efm.setup({
	capabilities = capabilities,
	on_attach = M.on_attach,
	init_options = { documentFormatting = true },
	root_dir = vim.loop.cwd,
	settings = {
		rootMarkers = { ".git/" },
		lintDebounce = 100,
		-- logLevel = 5,
		languages = {
			["="] = { misspell },
			vim = { vint },
			lua = { stylua, luacheck },
			go = { staticcheck, goimports, go_vet },
			python = { black, isort, flake8, mypy },
			typescript = { prettier, eslint },
			javascript = { prettier, eslint },
			typescriptreact = { prettier, eslint },
			javascriptreact = { prettier, eslint },
			yaml = { prettier },
			json = { prettier },
			html = { prettier },
			scss = { prettier },
			css = { prettier },
			markdown = { prettier },
			sh = { shellcheck, shfmt },
			terraform = { terraform },
			rego = { opa },
		},
	},
})

-- requires a file containing user's lspconfigs
local addlsp_confs = utils.load_config().plugins.options.lspconfig.setup_lspconf

if #addlsp_confs ~= 0 then
	require(addlsp_confs).setup_lsp(M.on_attach, capabilities)
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	virtual_text = false,
})

return M
