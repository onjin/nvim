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
