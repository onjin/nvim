-- luacheck: globals vim
-- n, v, i, t = mode names

local function termcodes(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local home = os.getenv("HOME")

local F = {}
function F.edit_nvim()
	require("telescope.builtin").git_files({
		shorten_path = true,
		cwd = "~/.config/nvim",
		prompt = "~ nvim ~",
		height = 10,
		layout_strategy = "horizontal",
		layout_options = { preview_width = 0.75 },
	})
end

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
		-- ["<C-h>"] = { "<C-w>h", " window left" },
		-- ["<C-l>"] = { "<C-w>l", " window right" },
		-- ["<C-j>"] = { "<C-w>j", " window down" },
		-- ["<C-k>"] = { "<C-w>k", " window up" },
		-- save
		["<C-s>"] = { "<cmd> w <CR>", "﬚  save file" },

		-- Copy all
		["<C-c>"] = { "<cmd> %y+ <CR>", "  copy whole file" },

		-- line numbers
		["<leader>n"] = { "<cmd> set nu! <CR>", "   toggle line number" },
		["<leader>rn"] = { "<cmd> set rnu! <CR>", "   toggle relative number" },

		-- update nvchad
		["<leader>uu"] = { "<cmd> :NvChadUpdate <CR>", "  update nvchad" },

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
		["<C-x>"] = { [[<C-\><C-n>]], opts = { buffer = 0 }, "   escape terminal mode" },
		["<C-h>"] = { [[<Cmd>wincmd h<CR>]], opts = { buffer = 0 } },
		["<C-j>"] = { [[<Cmd>wincmd j<CR>]], opts = { buffer = 0 } },
		["<C-k>"] = { [[<Cmd>wincmd k<CR>]], opts = { buffer = 0 } },
		["<C-l>"] = { [[<Cmd>wincmd l<CR>]], opts = { buffer = 0 } },
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
		["<leader>Tp"] = { "<cmd> tabprevious <CR>", "  goto next tab" },
		["<leader>Tn"] = { "<cmd> tabnext <CR> ", "  goto prev tab" },

		-- close buffer + hide terminal buffer
		["<leader>x"] = { "<cmd> :bd <CR>", "   close buffer" },

		-- buffers shortcuts
		["<leader>1"] = { "<cmd> LualineBuffersJump 1  <CR>", "jump to buffer 1" },
		["<leader>2"] = { "<cmd> LualineBuffersJump 2  <CR>", "jump to buffer 2" },
		["<leader>3"] = { "<cmd> LualineBuffersJump 3  <CR>", "jump to buffer 3" },
		["<leader>4"] = { "<cmd> LualineBuffersJump 4  <CR>", "jump to buffer 4" },
		["<leader>5"] = { "<cmd> LualineBuffersJump 5  <CR>", "jump to buffer 5" },
		["<leader>6"] = { "<cmd> LualineBuffersJump 6  <CR>", "jump to buffer 6" },
		["<leader>7"] = { "<cmd> LualineBuffersJump 7  <CR>", "jump to buffer 7" },
		["<leader>8"] = { "<cmd> LualineBuffersJump 8  <CR>", "jump to buffer 8" },
		["<leader>9"] = { "<cmd> LualineBuffersJump 9  <CR>", "jump to buffer 9" },
		["<leader>0"] = { "<cmd> LualineBuffersJump 10  <CR>", "jump to buffer 10" },
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
			-- function()
			-- 	require("telescope.builtin").lsp_definitions()
			-- end,
			"<cmd>Lspsaga peek_definition<CR>",
			"   lsp definition",
		},

		["K"] = {
			-- function()
			-- 	vim.lsp.buf.hover()
			-- end,
			"<cmd>Lspsaga hover_doc<CR>",
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
			-- function()
			-- 	require("telescope.builtin").lsp_references()
			-- end,
			"<cmd>Lspsaga lsp_finder<CR>",
			"   lsp references",
		},
		["gs"] = {
			function()
				-- vim.lsp.buf.references()
				require("telescope.builtin").lsp_document_symbols()
			end,
			"   lsp document symbols",
		},

		["<leader>f"] = {
			-- function()
			-- 	vim.diagnostic.open_float()
			-- end,
			"<cmd>Lspsaga show_line_diagnostics<CR>",
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

		["<leader>ft"] = { "<cmd> Telescope file_browser <CR>", "   open file browser" },
		["<leader><leader>e"] = { F.edit_nvim, "   open ~/.config/nvim" },
		["<leader><leader>d"] = {
			"<cmd> Telescope file_browser path=" .. home .. "/dotfiles <CR>",
			"   open ~/dotfiles",
		},
		["<leader><leader>n"] = {
			"<cmd> Telescope file_browser path=" .. home .. "/notes <CR>",
			"   open ~/notes",
		},

		["<leader>vk"] = { "<cmd> Telescope keymaps <CR>", "   show keys" },

		-- git
		["<leader>fg"] = { "<cmd> Telescope git_files <CR>", "  git files" },

		["<leader>gm"] = { "<cmd> Telescope git_commits <CR>", "   git commits" },
		["<leader>gt"] = { "<cmd> Telescope git_status <CR>", "  git status" },
		["<leader>gf"] = { "<cmd> Telescope git_files <CR>", "  git files" },
		["<leader>gb"] = { "<cmd> Git blame_line <CR>", "  git blame line" },

		["<C-p>"] = { "<cmd> Telescope find_files <CR>", "  find files" },
		["<C-P>"] = { "<cmd> Telescope git_files <CR>", "  git files" },

		-- pick a hidden term
		["<leader>pt"] = { "<cmd> Telescope terms <CR>", "   pick hidden term" },

		-- theme switcher
		["<leader>sc"] = { "<cmd> Telescope colorscheme <CR>", "   themes" },

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

M.vimux = {
	n = {
		-- ["<leader>tr"] = { ':lua require("neotest").run.run()<cr>', "λ Run tests" },
		["<leader>vp"] = { ":VimuxPromptCommand<cr>", "~ Run prompted command in vimux runner" },
		["<leader>vo"] = { ":VimuxOpenRunner<cr>", "~ Open vimux runner" },
		["<leader>vz"] = { ":VimuxZoomRunner<cr>", "~ Zoom vimux runner" },
		["<leader>vq"] = { ":VimuxCloseRunner<cr>", "~ Close vimux runner" },
		["<leader>vx"] = { ":VimuxInterruptRunner<cr>", "~ Interrupt vimux runner process" },
		["<leader>vi"] = { ":VimuxInspectRunner<cr>", "~ Inspect vimux runner" },
		["<leader>v<C-l>"] = { ":VimuxClearTerminalScreen<cr>", "~ Clear screen of vimux runner" },
	},
}

M.neotest = {

	n = {
		-- ["<leader>tr"] = { ':lua require("neotest").run.run()<cr>', "λ Run tests" },
		["<leader>tr"] = { ":TestNearest<cr>", "λ Run tests" },
		-- ["<leader>tl"] = { ':lua require("neotest").run.run_last()<cr>', "λ Run last test" },
		["<leader>tl"] = { ":TestLast<cr>", "λ Run last test" },
		-- ["<leader>tf"] = { ':lua require("neotest").run.run(vim.fn.expand("%"))<cr>', "λ Test file" },
		["<leader>tf"] = { ":TestFile<cr>", "λ Test file" },
		["<leader>tu"] = { ':lua require("neotest").run.stop()<cr>', "λ Stop tests" },
		["<leader>ta"] = { ':lua require("neotest").run.attach()<cr>', "λ Attach to tests" },

		["<leader>tw"] = { ':lua require("neotest").summary.toggle()<cr>', "λ Toggle tests sumamry" },
		["<leader>to"] = { ':lua require("neotest").output.open()<cr>', "λ Open output window" },
		["<leader>ts"] = { ':lua require("neotest").output.open({ short = true })<cr>', "λ Open output summary" },
	},
}

M.gitsigns = {
	n = {
		["<leader>hs"] = { ":Gitsigns stage_hunk<cr>", "  stage hunk" },
		["<leader>hr"] = { ":Gitsigns reset_hunk<cr>", "  reset hunk" },
		["<leader>hS"] = { ":lua require('gitsigns').stage_buffer()<cr>", "  stage buffer" },
		["<leader>hu"] = { ":lua require('gitsigns').undo_stage_hunk()<cr>", "  undo stage buffer" },
		["<leader>hR"] = { ":lua require('gitsigns').reset_buffer()<cr>", "  reset buffer" },
		["<leader>hp"] = { ":lua require('gitsigns').preview_hunk()<cr>", "  preview hunk" },
		["<leader>hb"] = {
			function()
				require("gitsigns").blame_line({ full = true })
			end,
			"  blame line",
		},
		["<leader>hd"] = { ":lua require('gitsigns').diffthis()<cr>", "  diff this" },
		["<leader>hD"] = {
			function()
				require("gitsigns").diffthis("~")
			end,
			"  diff this",
		},
		-- toggle
		["<leader>Tb"] = { ":lua require('gitsigns').toggle_current_line_blame()<cr>", "  toggle blame" },
		["<leader>Td"] = { ":lua require('gitsigns').toggle_deleted()<cr>", "  toggle deleted" },
	},
	v = {
		["<leader>hs"] = { ":Gitsigns stage_hunk<cr>", "  stage hunk" },
		["<leader>hr"] = { ":Gitsigns reset_hunk<cr>", "  reset hunk" },
	},
	o = {
		["ih"] = { ":<C-U>Gitsigns select_hunk<CR>" },
	},
	x = {
		["ih"] = { ":<C-U>Gitsigns select_hunk<CR>" },
	},
}
M.lspsaga = {
	n = {
		-- find
		["<leader>tt"] = { "<cmd>LSoutlineToggle<CR>", "  toggle outline" },
		["<leader>sf"] = { "<cmd>Lspsaga lsp_finder<CR>", "  LSP finder" },
		["<leader>sa"] = { "<cmd>Lspsaga code_action<CR>", "  LSP Code action" },
		["<leader>sr"] = { "<cmd>Lspsaga rename<CR>", "  LSP Rename" },
		["<leader>sd"] = { "<cmd>Lspsaga peek_definition<CR>", "  LSP Peek definition" },
		["<leader>st"] = { "<cmd>Lspsaga open_floaterm<CR>", "  LSP Floating term" },
	},
}

M.cargo = {
	n = {
		["<leader>ct"] = { ":lua require('crates').toggle()<cr>", "[Cargo] toggle" },
		["<leader>cr"] = { ":lua require('crates').reload()<cr>", "[Cargo] reload" },

		["<leader>cv"] = { ":lua require('crates').show_versions_popup()<cr>", "[Cargo] show versions" },
		["<leader>cf"] = { ":lua require('crates').show_features_popup()<cr>", "[Cargo] show features" },
		["<leader>cd"] = { ":lua require('crates').show_dependencies_popup()<cr>", "[Cargo] show dependencies" },

		["<leader>cu"] = { ":lua require('crates').update_crate()<cr>", "[Cargo] update crate" },
		["<leader>ca"] = { ":lua require('crates').update_all_crates()<cr>", "[Cargo] update all" },
		["<leader>cU"] = { ":lua require('crates').upgrade_crate()<cr>", "[Cargo] upgrade crate" },
		["<leader>cA"] = { ":lua require('crates').upgrade_all_crates()<cr>", "[Cargo] upgrade all" },

		["<leader>cC"] = { ":lua require('crates').focus_popup()<cr>", "[Cargo] focus popup" },
	},
	v = {
		["<leader>cu"] = { ":lua require('crates').update_crates()<cr>", "[Cargo] update crates" },
		["<leader>cU"] = { ":lua require('crates').upgrade_crates()<cr>", "[Cargo] upgrade crates" },
	},
}

M.folding = {
	n = {
		["<leader>Ft"] = { ":lua require('core.utils').toggle_folding()<cr>", "Toggle folding" },
	},
}

M.diagnostic = {
	n = {
		["<leader>ds"] = { ":lua vim.diagnostic.show(nil, 0)<cr>", " Show diagnostic (buf)" },
		["<leader>dh"] = { ":lua vim.diagnostic.hide(nil, 0)<cr>", " Hide diagnostic (buf)" },
		["<leader>dd"] = { ":lua vim.diagnostic.disable(0)<cr>", " Disable diagnostic (buf)" },
		["<leader>de"] = { ":lua vim.diagnostic.enable(0)<cr>", " Enable diagnostic (buf)" },
	},
}

return M
--[[
-- for python
    map('n', '<leader>cf', '<cmd>:Black<cr>')
    map('v', '<leader>cf', '<cmd>vim.notify("code range format not supported with Black")<cr>')
    map('n', '<leader>ci', '<cmd>PyrightOrganizeImports<cr>')

 ]]
