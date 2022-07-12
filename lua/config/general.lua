local g = vim.g       -- Global variables
local opt = vim.opt   -- Set options (global/buffer/windows-scoped)

require "trouble" .setup()
require "nvim-autopairs" .setup()
require "cosmic-ui" .setup()
require "todo-comments" .setup()

-- notifications
require("notify").setup({level='info'})
vim.notify = require("notify")
require('telescope').load_extension('notify')

-- fidget
require("fidget").setup()

-- which key
require("which-key").setup {
  -- your configuration comes here
  -- or leave it empty to use the default settings
  -- refer to the configuration section below
}

-- rest calls
require("rest-nvim").setup({
  -- Open request results in a horizontal split
  result_split_horizontal = false,
  -- Keep the http file buffer above|left when split horizontal|vertical
  result_split_in_place = false,
  -- Skip SSL verification, useful for unknown certificates
  skip_ssl_verification = false,
  -- Highlight request on run
  highlight = {
    enabled = true,
    timeout = 150,
  },
  result = {
    -- toggle showing URL, HTTP info, headers at top the of result window
    show_url = true,
    show_http_info = true,
    show_headers = true,
  },
  -- Jump to request line on run
  jump_to_request = false,
  env_file = '.env',
  custom_dynamic_variables = {},
  yank_dry_run = true,
})
vim.keymap.set("n", "<leader>u", "<Plug>RestNvim", { noremap = true, silent = true })

-- tmux
require("tmux").setup({
    -- overwrite default configuration
    -- here, e.g. to enable default bindings
    copy_sync = {
        -- enables copy sync and overwrites all register actions to
        -- sync registers *, +, unnamed, and 0 till 9 from tmux in advance
        enable = true,
    },
    navigation = {
        -- enables default keybindings (C-hjkl) for normal mode
        enable_default_keybindings = true,
    },
    resize = {
        -- enables default keybindings (A-hjkl) for normal mode
        enable_default_keybindings = true,
    }
})

-- auto session
require('auto-session').setup {
  log_level = 'info',
  auto_session_suppress_dirs = {'~/', '/tmp'}
}
require('session-lens').setup({
  path_display = {'shorten'},
  theme_conf = { border = true },
  previewer = false
})

-- indenting

-- vim.opt.list = true
-- vim.opt.listchars:append("space:⋅")
-- vim.opt.listchars:append("eol:↴")

require("indent_blankline").setup {
    -- for example, context is off by default, use this to turn it on
    show_current_context = true,
    show_current_context_start = true,
    show_end_line = true,
    space_char_blankline = " ",
}

-- buffers
g.buffet_show_index = true

-- vim-pad
g.pad_set_mappings = false
g.pad_dir = "~/Dropbox/Notes"
g.pad_local_dir = ".notes"
g.pad_default_format = "markdown"
g.pad_open_in_split = false

-- vista / tagbar
vim.g["vista_default_executive"] = 'nvim_lsp'
vim.g[":vista_fzf_preview"] = {'right:30%'}
vim.g[":vista#renderer#enable_icon"] = true

-- themes
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

require('catppuccin').setup({
  transparent_background = false,
  term_colors = false,
  styles = {
    comments = "italic",
    conditionals = "italic",
    loops = "NONE",
    functions = "italic",
    keywords = "NONE",
    strings = "NONE",
    variables = "NONE",
    numbers = "NONE",
    booleans = "NONE",
    properties = "NONE",
    types = "italic",
    operators = "NONE",
  },
  integrations = {
    treesitter = true,
    native_lsp = {
      enabled = true,
      virtual_text = {
        errors = "italic",
        hints = "italic",
        warnings = "italic",
        information = "italic",
      },
      underlines = {
        errors = "underline",
        hints = "underline",
        warnings = "underline",
        information = "underline",
      },
    },
    coc_nvim = false,
    lsp_trouble = true,
    cmp = true,
    lsp_saga = false,
    gitgutter = true,
    gitsigns = true,
    telescope = true,
    nvimtree = {
      enabled = true,
      show_root = false,
      transparent_panel = false,
    },
    neotree = {
      enabled = false,
      show_root = false,
      transparent_panel = false,
    },
    which_key = true,
    indent_blankline = {
      enabled = true,
      colored_indent_levels = false,
    },
    dashboard = true,
    neogit = false,
    vim_sneak = false,
    fern = false,
    barbar = false,
    bufferline = true,
    markdown = true,
    lightspeed = false,
    ts_rainbow = false,
    hop = false,
    notify = true,
    telekasten = true,
    symbols_outline = true,
  }
})
vim.g.catppuccin_flavour = "mocha" -- latte, frappe, macchiato, mocha
