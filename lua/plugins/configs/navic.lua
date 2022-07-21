local present, navic = pcall(require, "nvim-navic")

if not present then
	return
end

local options = {
	highlight = true,
	separator = " -> ",
	depth_limit = 0,
	depth_limit_indicator = "..",
}
options = require("core.utils").load_override(options, "SmiteshP/nvim-navic")

local colors = {
	rosewater = "#F5E0DC",
	flamingo = "#F2CDCD",
	pink = "#F5C2E7",
	mauve = "#CBA6F7",
	red = "#F38BA8",
	maroon = "#EBA0AC",
	peach = "#FAB387",
	yellow = "#F9E2AF",
	green = "#A6E3A1",
	teal = "#94E2D5",
	sky = "#89DCEB",
	sapphire = "#74C7EC",
	blue = "#89B4FA",
	lavender = "#B4BEFE",

	text = "#CDD6F4",
	subtext1 = "#BAC2DE",
	subtext0 = "#A6ADC8",
	overlay2 = "#9399B2",
	overlay1 = "#7F849C",
	overlay0 = "#6C7086",
	surface2 = "#585B70",
	surface1 = "#45475A",
	surface0 = "#313244",

	base = "#1E1E2E",
	mantle = "#181825",
	crust = "#11111B",
}

local navic_colors = {
	text = colors.text,
	separator = colors.blue,
	icon = colors.yellow,
	background = colors.mantle,
}

vim.api.nvim_set_hl(0, "NavicIconsFile", { default = true, bg = navic_colors.background, fg = navic_colors.icon })
vim.api.nvim_set_hl(0, "NavicIconsModule", { default = true, bg = navic_colors.background, fg = navic_colors.icon })
vim.api.nvim_set_hl(0, "NavicIconsNamespace", { default = true, bg = navic_colors.background, fg = navic_colors.icon })
vim.api.nvim_set_hl(0, "NavicIconsPackage", { default = true, bg = navic_colors.background, fg = navic_colors.icon })
vim.api.nvim_set_hl(0, "NavicIconsClass", { default = true, bg = navic_colors.background, fg = navic_colors.icon })
vim.api.nvim_set_hl(0, "NavicIconsMethod", { default = true, bg = navic_colors.background, fg = navic_colors.icon })
vim.api.nvim_set_hl(0, "NavicIconsProperty", { default = true, bg = navic_colors.background, fg = navic_colors.icon })
vim.api.nvim_set_hl(0, "NavicIconsField", { default = true, bg = navic_colors.background, fg = navic_colors.icon })
vim.api.nvim_set_hl(
	0,
	"NavicIconsConstructor",
	{ default = true, bg = navic_colors.background, fg = navic_colors.icon }
)
vim.api.nvim_set_hl(0, "NavicIconsEnum", { default = true, bg = navic_colors.background, fg = navic_colors.icon })
vim.api.nvim_set_hl(0, "NavicIconsInterface", { default = true, bg = navic_colors.background, fg = navic_colors.icon })
vim.api.nvim_set_hl(0, "NavicIconsFunction", { default = true, bg = navic_colors.background, fg = navic_colors.icon })
vim.api.nvim_set_hl(0, "NavicIconsVariable", { default = true, bg = navic_colors.background, fg = navic_colors.icon })
vim.api.nvim_set_hl(0, "NavicIconsConstant", { default = true, bg = navic_colors.background, fg = navic_colors.icon })
vim.api.nvim_set_hl(0, "NavicIconsString", { default = true, bg = navic_colors.background, fg = navic_colors.icon })
vim.api.nvim_set_hl(0, "NavicIconsNumber", { default = true, bg = navic_colors.background, fg = navic_colors.icon })
vim.api.nvim_set_hl(0, "NavicIconsBoolean", { default = true, bg = navic_colors.background, fg = navic_colors.icon })
vim.api.nvim_set_hl(0, "NavicIconsArray", { default = true, bg = navic_colors.background, fg = navic_colors.icon })
vim.api.nvim_set_hl(0, "NavicIconsObject", { default = true, bg = navic_colors.background, fg = navic_colors.icon })
vim.api.nvim_set_hl(0, "NavicIconsKey", { default = true, bg = navic_colors.background, fg = navic_colors.icon })
vim.api.nvim_set_hl(0, "NavicIconsNull", { default = true, bg = navic_colors.background, fg = navic_colors.icon })
vim.api.nvim_set_hl(0, "NavicIconsEnumMember", { default = true, bg = navic_colors.background, fg = navic_colors.icon })
vim.api.nvim_set_hl(0, "NavicIconsStruct", { default = true, bg = navic_colors.background, fg = navic_colors.icon })
vim.api.nvim_set_hl(0, "NavicIconsEvent", { default = true, bg = navic_colors.background, fg = navic_colors.icon })
vim.api.nvim_set_hl(0, "NavicIconsOperator", { default = true, bg = navic_colors.background, fg = navic_colors.icon })
vim.api.nvim_set_hl(
	0,
	"NavicIconsTypeParameter",
	{ default = true, bg = navic_colors.background, fg = navic_colors.icon }
)
vim.api.nvim_set_hl(0, "NavicText", { default = true, bg = navic_colors.background, fg = navic_colors.text })
vim.api.nvim_set_hl(0, "NavicSeparator", { default = true, bg = navic_colors.background, fg = navic_colors.separator })

navic.setup(options)
