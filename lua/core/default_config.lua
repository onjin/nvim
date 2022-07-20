-- Chadrc overrides this file

local M = {}

M.options = {
	-- load your options here or load module with options
	user = function() end,
}

M.ui = {
	-- hl = highlights
	hl_add = {},
	hl_override = {},
	changed_themes = {},
	theme_toggle = { "onedark", "one_light" },
	theme = "onedark", -- default theme
	transparency = false,
}

M.plugins = {
	override = {},
	remove = {},
	user = {},
	options = {
		lspconfig = {
			setup_lspconf = "", -- path of lspconfig file
		},
	},
}

-- check core.mappings for table structure
M.mappings = require("core.mappings")

return M
