vim.o.background = "dark"

require('ayu').setup({
  overrides = {
    CurSearch = { bg = '#F1AE00' , fg = '#000000'},
    IncSearch = { bg = '#e92063' },
    NormalNC = {bg = '#0f151e', fg = '#808080'},
    CursorLine = { bg = "#2e2e2e" },
  }
})
-- vim.cmd('colorscheme ayu-dark')
require('rose-pine').setup({
	--- @usage 'main' | 'moon'
	dark_variant = 'main',
	bold_vert_split = false,
	dim_nc_background = false,
	disable_background = false,
	disable_float_background = false,
	disable_italics = false,

	--- @usage string hex value or named color from rosepinetheme.com/palette
	groups = {
		background = 'base',
		panel = 'surface',
		border = 'highlight_med',
		comment = 'muted',
		link = 'iris',
		punctuation = 'subtle',

		error = 'love',
		hint = 'iris',
		info = 'foam',
		warn = 'gold',

		headings = {
			h1 = 'iris',
			h2 = 'foam',
			h3 = 'rose',
			h4 = 'gold',
			h5 = 'pine',
			h6 = 'foam',
		}
		-- or set all headings at once
		-- headings = 'subtle'
	},

	-- Change specific vim highlight groups
	highlight_groups = {
		ColorColumn = { bg = 'rose' }
	}
})

require('catppuccin').setup()
vim.g.catppuccin_flavour = "mocha" -- latte, frappe, macchiato, mocha

-- set colorscheme after options
-- vim.cmd('colorscheme rose-pine')
-- default colorscheme, might be changed and saved using `:lua requre'utils' colors('schema')`
vim.cmd('colorscheme catppuccin')
