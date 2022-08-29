-- Chadrc overrides this file

local M = {}

M.options = {
	-- load your options here or load module with options
	user = function() end,
  -- whether display diagnostic text after the line
  lsp_virtual_test = true,
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
}

-- check core.mappings for table structure
M.mappings = require("core.mappings")

return M
