-- n, v, i, t = mode names

local function termcodes(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local home = os.getenv("HOME")

local M = {}

M.general = {
	i = {

		-- go to  beginning and end
		["<C-b>"] = { "<ESC>^i", "論 beginning of line" },
		["<C-e>"] = { "<End>", "壟 end of line" },

		-- navigate within insert mode
		["<C-h>"] = { "<Left>", "  move left" },
		["<C-l>"] = { "<Right>", " move right" },
		["<C-j>"] = { "<Down>", " move down" },
		["<C-k>"] = { "<Up>", " move up" },
	},
	n = {

		["<ESC>"] = { "<cmd> noh <CR>", "  no highlight" },
		-- registers :reg
		["<leader>pp"] = { "*pp", "paste from *pp" },
		-- conceal level
		["<leader>vc"] = {
			":setlocal <C-R>=&conceallevel ? 'conceallevel=0' : 'conceallevel=2'<CR><CR>",
			"toggle conceal level",
		},

		-- switch between windows
		["<C-h>"] = { "<C-w>h", " window left" },
		["<C-l>"] = { "<C-w>l", " window right" },
		["<C-j>"] = { "<C-w>j", " window down" },
		["<C-k>"] = { "<C-w>k", " window up" },
		-- save
		["<C-s>"] = { "<cmd> w <CR>", "﬚  save file" },

		-- Copy all
		["<C-c>"] = { "<cmd> %y+ <CR>", "  copy whole file" },

		-- line numbers
		["<leader>n"] = { "<cmd> set nu! <CR>", "   toggle line number" },
		["<leader>rn"] = { "<cmd> set rnu! <CR>", "   toggle relative number" },

		-- update nvchad
		["<leader>uu"] = { "<cmd> :NvChadUpdate <CR>", "  update nvchad" },

		["<leader>tt"] = {
			function()
				require("base46").toggle_theme()
			end,

			"   change theme",
		},

		-- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
		-- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
		-- empty mode is same as using <cmd> :map
		-- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
		["j"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', opts = { expr = true } },
		["k"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', opts = { expr = true } },
		["<Up>"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', opts = { expr = true } },
		["<Down>"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', opts = { expr = true } },
	},

	t = {
		["<C-x>"] = { termcodes("<C-\\><C-N>"), "   escape terminal mode" },
		["<C-h>"] = { termcodes("<C-\\><C-N><C-w>h") },
		["<C-j>"] = { termcodes("<C-\\><C-N><C-w>j") },
		["<C-k>"] = { termcodes("<C-\\><C-N><C-w>k") },
		["<C-l>"] = { termcodes("<C-\\><C-N><C-w>l") },
	},

	v = {
		["j"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', opts = { expr = true } },
		["k"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', opts = { expr = true } },
		["<Up>"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', opts = { expr = true } },
		["<Down>"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', opts = { expr = true } },
		-- Don't copy the replaced text after pasting in visual mode
		-- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
		["p"] = { 'p:let @+=@0<CR>:let @"=@0<CR>', opts = { silent = true } },
		-- allow to use `.` on visual selections
		["."] = { ":norm.<CR>" },
	},
}

M.buffers = {

	n = {
		-- new buffer
		["<S-b>"] = { "<cmd> enew <CR>", "烙 new buffer" },

		-- cycle through buffers
		["<TAB>"] = { "<cmd> :bn <CR>", "  goto next buffer" },
		["<S-Tab>"] = { "<cmd> :bp <CR> ", "  goto prev buffer" },

		-- cycle through tabs
		["<leader>tp"] = { "<cmd> tabprevious <CR>", "  goto next tab" },
		["<leader>tn"] = { "<cmd> tabnext <CR> ", "  goto prev tab" },

		-- close buffer + hide terminal buffer
		["<leader>x"] = { "<cmd> :bd <CR>", "   close buffer" },

		-- buffers shortcuts
		["<leader>1"] = { ":call buffet#bswitch(1) <CR>", "   jump to buffer 1" },
		["<leader>2"] = { ":call buffet#bswitch(2) <CR>", "   jump to buffer 2" },
		["<leader>3"] = { ":call buffet#bswitch(3) <CR>", "   jump to buffer 3" },
		["<leader>4"] = { ":call buffet#bswitch(4) <CR>", "   jump to buffer 4" },
		["<leader>5"] = { ":call buffet#bswitch(5) <CR>", "   jump to buffer 5" },
		["<leader>6"] = { ":call buffet#bswitch(6) <CR>", "   jump to buffer 6" },
		["<leader>7"] = { ":call buffet#bswitch(7) <CR>", "   jump to buffer 7" },
		["<leader>8"] = { ":call buffet#bswitch(8) <CR>", "   jump to buffer 8" },
		["<leader>9"] = { ":call buffet#bswitch(9) <CR>", "   jump to buffer 9" },
		["<leader>0"] = { ":call buffet#bswitch(10) <CR>", "   jump to buffer 10" },
	},
}
M.comment = {

	-- toggle comment in both modes
	n = {
		["<leader>/"] = {
			function()
				require("Comment.api").toggle_current_linewise()
			end,

			"蘒  toggle comment",
		},
	},

	v = {
		["<leader>/"] = {
			"<ESC><cmd>lua require('Comment.api').toggle_linewise_op(vim.fn.visualmode())<CR>",
			"蘒  toggle comment",
		},
	},
}

M.lspconfig = {
	-- See `<cmd> :help vim.lsp.*` for documentation on any of the below functions

	n = {
		["gD"] = {
			function()
				vim.lsp.buf.declaration()
			end,
			"   lsp declaration",
		},

		["gd"] = {
			function()
				-- vim.lsp.buf.definition()
				require("telescope.builtin").lsp_definitions()
			end,
			"   lsp definition",
		},

		["K"] = {
			function()
				vim.lsp.buf.hover()
			end,
			"   lsp hover",
		},

		["gi"] = {
			function()
				-- vim.lsp.buf.implementation()
				require("telescope.builtin").lsp_implementations()
			end,
			"   lsp implementation",
		},

		["<leader>ls"] = {
			function()
				-- vim.lsp.buf.signature_help()
				require("lsp_signature").signature()
			end,
			"   lsp signature_help",
		},

		["<leader>D"] = {
			function()
				-- vim.lsp.buf.type_definition()
				require("telescope.builtin").lsp_type_definitions()
			end,
			"   lsp definition type",
		},

		["<leader>ra"] = {
			function()
				require("cosmic-ui").rename()
			end,
			"   lsp rename",
		},

		["<leader>ca"] = {
			function()
				-- vim.lsp.buf.code_action()
				require("cosmic-ui").code_actions()
			end,
			"   lsp code_action",
		},

		["gr"] = {
			function()
				-- vim.lsp.buf.references()
				require("telescope.builtin").lsp_references()
			end,
			"   lsp references",
		},
		["gs"] = {
			function()
				-- vim.lsp.buf.references()
				require("telescope.builtin").lsp_document_symbols()
			end,
			"   lsp references",
		},

		["<leader>f"] = {
			function()
				vim.diagnostic.open_float()
			end,
			"   floating diagnostic",
		},

		["[d"] = {
			function()
				vim.diagnostic.goto_prev()
			end,
			"   goto prev",
		},

		["d]"] = {
			function()
				vim.diagnostic.goto_next()
			end,
			"   goto_next",
		},

		["<leader>q"] = {
			function()
				vim.diagnostic.setloclist()
			end,
			"   diagnostic setloclist",
		},

		["<leader>fm"] = {
			function()
				vim.lsp.buf.format({ async = true })
			end,
			"   lsp formatting",
		},

		["<leader>wa"] = {
			function()
				vim.lsp.buf.add_workspace_folder()
			end,
			"   add workspace folder",
		},

		["<leader>wr"] = {
			function()
				vim.lsp.buf.remove_workspace_folder()
			end,
			"   remove workspace folder",
		},

		["<leader>wl"] = {
			function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end,
			"   list workspace folders",
		},
	},
}

M.nvimtree = {

	n = {
		-- toggle
		["<C-n>"] = { "<cmd> NvimTreeToggle <CR>", "   toggle nvimtree" },

		-- focus
		["<leader>e"] = { "<cmd> NvimTreeFocus <CR>", "   focus nvimtree" },
	},
}

M.telescope = {
	n = {
		-- find
		["<leader>ff"] = { "<cmd> Telescope find_files <CR>", "  find files" },
		["<leader>fa"] = { "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>", "  find all" },
		["<leader>fr"] = { "<cmd> Telescope live_grep <CR>", "   live grep" },
		["<leader>fb"] = { "<cmd> Telescope buffers <CR>", "  find buffers" },
		["<leader>fh"] = { "<cmd> Telescope help_tags <CR>", "  help page" },
		["<leader>fo"] = { "<cmd> Telescope oldfiles <CR>", "   find oldfiles" },
		["<leader>fn"] = {
			"<cmd> Telescope file_browser path=" .. home .. ".config/nvim <CR>",
			"   open ~/.config/nvim",
		},
		["<leader>fd"] = { "<cmd> Telescope file_browser path=" .. home .. "dotfiles <CR>", "   open dotfiles" },

		["<leader>vk"] = { "<cmd> Telescope keymaps <CR>", "   show keys" },

		-- git
		["<leader>cm"] = { "<cmd> Telescope git_commits <CR>", "   git commits" },
		["<leader>gt"] = { "<cmd> Telescope git_status <CR>", "  git status" },
		["<leader>fg"] = { "<cmd> Telescope git_files <CR>", "  git status" },

		["<C-p>"] = { "<cmd> Telescope find <CR>", "  find files" },
		["<C-P>"] = { "<cmd> Telescope git_files <CR>", "  git files" },

		-- pick a hidden term
		["<leader>pt"] = { "<cmd> Telescope terms <CR>", "   pick hidden term" },

		-- theme switcher
		["<leader>tc"] = { "<cmd> Telescope colorscheme <CR>", "   themes" },

		-- spelling
		["<leader>ss"] = { "<cmd> Telescope spell_sugges <CR>", "   spelling" },
	},
}

M.whichkey = {
	n = {
		["<leader>wK"] = {
			function()
				vim.cmd("WhichKey")
			end,
			"   which-key all keymaps",
		},
		["<leader>wk"] = {
			function()
				local input = vim.fn.input("WhichKey: ")
				vim.cmd("WhichKey " .. input)
			end,
			"   which-key query lookup",
		},
	},
}

M.blankline = {
	n = {
		["<leader>bc"] = {
			function()
				local ok, start = require("indent_blankline.utils").get_current_context(
					vim.g.indent_blankline_context_patterns,
					vim.g.indent_blankline_use_treesitter_scope
				)

				if ok then
					vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { start, 0 })
					vim.cmd([[normal! _]])
				end
			end,

			"  Jump to current_context",
		},
	},
}

M.neotest = {

	n = {
		["<leader>tr"] = { ':lua require("neotest").run.run()<cr>' },
		["<leader>tl"] = { ':lua require("neotest").run.run_last()<cr>' },
		["<leader>tf"] = { ':lua require("neotest").run.run(vim.fn.expand("%"))<cr>' },
		["<leader>tu"] = { ':lua require("neotest").run.stop()<cr>' },
		["<leader>ta"] = { ':lua require("neotest").run.attach()<cr>' },

		["<leader>tw"] = { ':lua require("neotest").summary.toggle()<cr>' },
		["<leader>to"] = { ':lua require("neotest").output.open()<cr>' },
		["<leader>ts"] = { ':lua require("neotest").output.open({ short = true })<cr>' },
	},
}

return M
--[[
-- for python
    map('n', '<leader>cf', '<cmd>:Black<cr>')
    map('v', '<leader>cf', '<cmd>vim.notify("code range format not supported with Black")<cr>')
    map('n', '<leader>ci', '<cmd>PyrightOrganizeImports<cr>')

 ]]
