local g = vim.g       -- Global variables
local opt = vim.opt   -- Set options (global/buffer/windows-scoped)

require "trouble" .setup()
require "cosmic-ui" .setup()

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

-- vista / tagbar
vim.g["vista_default_executive"] = 'nvim_lsp'
vim.g[":vista_fzf_preview"] = {'right:30%'}
vim.g[":vista#renderer#enable_icon"] = true
