vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" })

-- Ensure custom Treesitter directives are registered before any parser starts.
pcall(require, "nvim-treesitter.query_predicates")

do
	local query = vim.treesitter.query
	local opts = vim.fn.has("nvim-0.10") == 1 and { force = true, all = false } or true
	local non_filetype_match_injection_language_aliases = {
		ex = "elixir",
		pl = "perl",
		sh = "bash",
		ts = "typescript",
		uxn = "uxntal",
	}
	local html_script_type_languages = {
		importmap = "json",
		module = "javascript",
		["application/ecmascript"] = "javascript",
		["text/ecmascript"] = "javascript",
	}

	local function captured_node(match, capture_id)
		local node = match[capture_id]
		if type(node) == "table" then
			return node[#node]
		end
		return node
	end

	local function parser_from_info_string(injection_alias)
		local match = vim.filetype.match({ filename = "a." .. injection_alias })
		return match or non_filetype_match_injection_language_aliases[injection_alias] or injection_alias
	end

	query.add_directive("set-lang-from-mimetype!", function(match, _, bufnr, pred, metadata)
		local node = captured_node(match, pred[2])
		if not node then
			return
		end
		local type_attr_value = vim.treesitter.get_node_text(node, bufnr)
		metadata["injection.language"] = html_script_type_languages[type_attr_value]
			or vim.split(type_attr_value, "/", {})[#vim.split(type_attr_value, "/", {})]
	end, opts)

	query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
		local node = captured_node(match, pred[2])
		if not node then
			return
		end
		local injection_alias = vim.treesitter.get_node_text(node, bufnr):lower()
		metadata["injection.language"] = parser_from_info_string(injection_alias)
	end, opts)

	query.add_directive("downcase!", function(match, _, bufnr, pred, metadata)
		local capture_id = pred[2]
		local node = captured_node(match, capture_id)
		if not node then
			return
		end
		local capture_metadata = metadata[capture_id]
		local text = vim.treesitter.get_node_text(node, bufnr, { metadata = capture_metadata }) or ""
		metadata[capture_id] = metadata[capture_id] or {}
		metadata[capture_id].text = string.lower(text)
	end, opts)
end

do
	local api = vim.api

	local function complete_available_parsers(arglead)
		local ok, config = pcall(require, "nvim-treesitter.config")
		if not ok then
			return {}
		end
		return vim.tbl_filter(function(parser)
			return parser:find(arglead, 1, true) ~= nil
		end, config.get_available())
	end

	local function complete_installed_parsers(arglead)
		local ok, config = pcall(require, "nvim-treesitter.config")
		if not ok then
			return {}
		end
		return vim.tbl_filter(function(parser)
			return parser:find(arglead, 1, true) ~= nil
		end, config.get_installed())
	end

	local function run_install_command(name, bang, args)
		local install = require("nvim-treesitter.install")
		local command = assert(install.commands[name], "Missing Treesitter command: " .. name)
		local runner = bang and command["run!"] or command.run
		return runner(unpack(args))
	end

	local function recreate_user_command(name, callback, opts)
		pcall(api.nvim_del_user_command, name)
		api.nvim_create_user_command(name, callback, opts)
	end

	recreate_user_command("TSInstall", function(args)
		run_install_command("TSInstall", args.bang, args.fargs)
	end, {
		nargs = "+",
		bang = true,
		bar = true,
		complete = complete_available_parsers,
		desc = "Install treesitter parsers",
	})

	recreate_user_command("TSInstallFromGrammar", function(args)
		run_install_command("TSInstallFromGrammar", args.bang, args.fargs)
	end, {
		nargs = "+",
		bang = true,
		bar = true,
		complete = complete_available_parsers,
		desc = "Install treesitter parsers from grammar",
	})

	recreate_user_command("TSUpdate", function(args)
		require("nvim-treesitter.install").commands.TSUpdate.run(unpack(args.fargs))
	end, {
		nargs = "*",
		bar = true,
		complete = complete_installed_parsers,
		desc = "Update installed treesitter parsers",
	})

	recreate_user_command("TSUninstall", function(args)
		require("nvim-treesitter.install").commands.TSUninstall.run(unpack(args.fargs))
	end, {
		nargs = "+",
		bar = true,
		complete = complete_installed_parsers,
		desc = "Uninstall treesitter parsers",
	})
end

-- Only highlight with treesitter
vim.cmd("syntax off")

vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		pcall(vim.treesitter.start)
	end,
})
