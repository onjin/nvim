local function opt()
	return {
		defaults = {
			vimgrep_arguments = {
				"rg",
				"--color=never",
				"--no-heading",
				"--with-filename",
				"--line-number",
				"--column",
				"--smart-case",
			},
			prompt_prefix = "   ",
			selection_caret = "  ",
			entry_prefix = "  ",
			initial_mode = "insert",
			selection_strategy = "reset",
			sorting_strategy = "ascending",
			layout_strategy = "horizontal",
			layout_config = {
				horizontal = {
					prompt_position = "top",
					preview_width = 0.55,
					results_width = 0.8,
				},
				vertical = {
					mirror = false,
				},
				width = 0.87,
				height = 0.80,
				preview_cutoff = 120,
			},
			file_sorter = require("telescope.sorters").get_fuzzy_file,
			file_ignore_patterns = { "node_modules" },
			generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
			path_display = { "truncate" },
			winblend = 0,
			border = {},
			-- borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
			borderchars = { "", "", "", "", "", "", "", "" },
			color_devicons = true,
			set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
			file_previewer = require("telescope.previewers").vim_buffer_cat.new,
			grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
			qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
			-- Developer configurations: Not meant for general override
			buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
			mappings = {
				n = { ["q"] = require("telescope.actions").close },
			},
		},
		extensions = {
			["ui-select"] = {
				require("telescope.themes").get_dropdown({}),
			},
			file_browser = {
				theme = "ivy",
				-- disables netrw and use telescope-file-browser in its place
				hijack_netrw = true,
			},
			sessions_picker = {
				sessions_dir = vim.fn.stdpath("data") .. "/sessions/",
			},
			lsp_handlers = {
				code_action = {
					telescope = require("telescope.themes").get_dropdown({}),
				},
			},
		},
	}
end

local function config()
	local t = require("telescope")
	t.setup(opt())
	t.load_extension("file_browser")
	t.load_extension("ui-select")
	vim.defer_fn(function()
		t.load_extension("gh")
		t.load_extension("notify")
		t.load_extension("projects")
		t.load_extension("repo")
		-- t.load_extension("session_picker")
		-- t.load_extension("conventional_commits")

		-- borderless layout
		local TelescopePrompt = {
			TelescopePromptNormal = {
				bg = "#2d3149",
			},
			TelescopePromptBorder = {
				bg = "#2d3149",
			},
			TelescopePromptTitle = {
				fg = "#2d3149",
				bg = "#2d3149",
			},
			TelescopePreviewTitle = {
				fg = "#1F2335",
				bg = "#1F2335",
			},
			TelescopeResultsTitle = {
				fg = "#1F2335",
				bg = "#1F2335",
			},
		}
		for hl, col in pairs(TelescopePrompt) do
			vim.api.nvim_set_hl(0, hl, col)
		end
	end, 5000)

	-- vim.api.nvim_create_autocmd("FileType", {
	-- 	pattern = "gitcommit",
	-- 	callback = function()
	-- 		vim.api.nvim_exec("Telescope conventional_commits", true)
	-- 		-- vim.keymap.set('n', '<leader>cc', ':Telescope conventional_commits<CR>', {
	-- 		-- 	buffer = true,
	-- 		--
	-- 		-- })
	-- 	end
	-- })
end

return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		lazy = false,
		config = config,
	},
	--[[ {
    "JoseConseco/telescope_sessions_picker.nvim",
    lazy=false,
  }, ]]
	--
	{ "nvim-telescope/telescope-file-browser.nvim" },
	{ "nvim-telescope/telescope-github.nvim" },
	{
		"nvim-telescope/telescope-project.nvim",
		dependencies = {
			"ahmedkhalf/project.nvim",
		},
	},
	{ "cljoly/telescope-repo.nvim" },
	{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
	{ "nvim-telescope/telescope-github.nvim" },
	{
		"nvim-telescope/telescope-ui-select.nvim",
		lazy = true,
		-- event = "VeryLazy",
	},
}
