local present, lualine = pcall(require, "lualine")

if not present then
	return
end

-- context from treesitter
local current_treesitter_context = function()
	local f = require("nvim-treesitter").statusline({
		indicator_size = 300,
		type_patterns = {
			"class",
			"function",
			"method",
			"interface",
			"type_spec",
			"table",
			"if_statement",
			"for_statement",
			"for_in_statement",
		},
	})
	local fun_name = string.format("%s", f) -- convert to string, it may be a empty ts node

	-- print(string.find(fun_name, "vim.NIL"))
	if fun_name == "vim.NIL" then
		return " "
	end
	return " " .. fun_name
end

local navic = require("nvim-navic")

--[[lualine_c = {
  { navic.get_location, cond = navic.is_available },
},]]

local options = {
	options = {
		icons_enabled = true,
		theme = "catppuccin",

		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = {},
		always_divide_middle = true,
		globalstatus = true,
		refresh = { -- sets how often lualine should refreash it's contents (in ms)
			statusline = 1000, -- The refresh option sets minimum time that lualine tries
			tabline = 1000, -- to maintain between refresh. It's not guarantied if situation
			winbar = 1000, -- arises that lualine needs to refresh itself before this time
			-- it'll do it.

			-- Also you can force lualine's refresh by calling refresh function
			-- like require('lualine').refresh()
		},
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = {
			require("auto-session-library").current_session_name,
			"filename",
			"lsp_progress",
		},
		lualine_x = { "encoding", "fileformat", "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {
		lualine_a = { { navic.get_location, cond = navic.is_available } },
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = { { "buffers", mode = 2 } },
		lualine_z = { "tabs" },
	},
	winbar = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {},
		lualine_x = {
      {"diff", separator = '|'},
      {"filename", separator = '|'},
      {"filetype", separator ='|'},
    },
		lualine_y = {},
		lualine_z = {},
	},
	inactive_winbar = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {},
		lualine_x = {
      {"diff", separator = '|'},
      {"filename", separator = '|'},
      {"filetype", separator ='|'},
    },
		lualine_y = {},
		lualine_z = {},
	},
	extensions = {},
}

lualine.setup(options)
