-- luacheck: globals vim
local present, cmp = pcall(require, "cmp")

if not present then
	return
end

-- require("base46").load_highlight "cmp"

vim.opt.completeopt = "menuone,noselect"

local function border(hl_name)
	return {
		{ "╭", hl_name },
		{ "─", hl_name },
		{ "╮", hl_name },
		{ "│", hl_name },
		{ "╯", hl_name },
		{ "─", hl_name },
		{ "╰", hl_name },
		{ "│", hl_name },
	}
end

local CompletionItemKind = {
	Text = " [text]",
	Method = " [method]",
	Function = " [function]",
	Constructor = " [constructor]",
	Field = "ﰠ [field]",
	Variable = " [variable]",
	Class = " [class]",
	Interface = " [interface]",
	Module = " [module]",
	Property = " [property]",
	Unit = " [unit]",
	Value = " [value]",
	Enum = " [enum]",
	Keyword = " [key]",
	Snippet = "﬌ [snippet]",
	Color = " [color]",
	File = " [file]",
	Reference = " [reference]",
	Folder = " [folder]",
	EnumMember = " [enum member]",
	Constant = " [constant]",
	Struct = " [struct]",
	Event = "⌘ [event]",
	Operator = " [operator]",
	TypeParameter = " [type]",
}

local cmp_window = require("cmp.utils.window")

cmp_window.info_ = cmp_window.info
cmp_window.info = function(self)
	local info = self:info_()
	info.scrollable = false
	return info
end

local options = {
	window = {
		completion = {
			border = border("CmpBorder"),
			winhighlight = "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None",
		},
		documentation = {
			border = border("CmpDocBorder"),
		},
	},
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	formatting = {
		format = function(entry, vim_item)
			local menu_map = {
				gh_issues = "[Issues]",
				buffer = "[Buf]",
				nvim_lsp = "[LSP]",
				nvim_lua = "[API]",
				path = "[Path]",
				luasnip = "[Snip]",
				tmux = "[Tmux]",
				look = "[Look]",
				rg = "[RG]",
        cmp_tabnine = "[Tabnine]",
			}
			vim_item.menu = menu_map[entry.source.name] or string.format("[%s]", entry.source.name)

			vim_item.kind = CompletionItemKind[vim_item.kind]
			return vim_item
		end,
	},
	mapping = {
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = false,
		}),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif require("luasnip").expand_or_jumpable() then
				vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif require("luasnip").jumpable(-1) then
				vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
	},
	sources = {
		{ name = "cmp_tabnine" },
		{ name = "luasnip" },
		{ name = "nvim_lsp" },
		{ name = "nvim_lua" },
		{ name = "buffer" },
		{ name = "path" },
		{ name = "emoji" },
		{ name = "crates" },
		{ name = "calc" },
	},
}

-- check for any override
options = require("core.utils").load_override(options, "hrsh7th/nvim-cmp")

cmp.setup(options)
