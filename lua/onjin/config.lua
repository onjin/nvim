local icons = require("onjin.icons")

local M = {}

-- primary leader key
M.leader_key = ","

-- secondary leader key
M.local_leader_key = " "

-- colorscheme
M.theme = "catppuccin"

-- for catppuccin theme you can set flavour latte, frappe, macchiato, mocha
M.theme_flavour = "mocha"

-- show spaces/new lines/etc
M.listchars = true

-- 1 - Symbols " ␋␤␠«»"
-- 2 - Fancy   " ▸¬●«»"
-- 3 - Plain   " >-$~<>"
-- mappings: <leader>cl - cycle listchars theme
-- configure: lua/onjin/icons.lua:availble_listchars
M.listchars_theme_number = 2

-- LSP // Initial servers for Mason
M.lsp_initial_servers = { "lua_ls", "efm", "pyright" }

-- LSP // EFM // default configuration loaded at lua/plugins/lsp.lua
M.lsp_efm_config_enabled = true

M.treesitter_initial_servers = {
    "bash",
    "comment",
    "dockerfile",
    "gitattributes",
    "gitignore",
    "html",
    "json",
    "latex",
    "lua",
    "make",
    "markdown",
    "markdown_inline",
    "python",
    "regex",
    "sql",
    "todotxt",
    "toml",
    "vim",
    "yaml",
}

-- Status line // Show lsp server names or just show number of attached servers
M.status_lsp_show_server_names = true

-- Status line // Prefix for LSP status - default `icons.misc.cog`
M.status_lsp_prefix = icons.misc.cog

return M
