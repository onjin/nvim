local g = vim.g -- Global variables
local opt = vim.opt -- Set options (global/buffer/windows-scoped)
local config = require("config")
local prefix = vim.env.XDG_STATE_HOME or vim.fn.expand("~/.local/state")

g.python_host_prog = "~/.pyenv/versions/neovim2/bin/python"
g.python3_host_prog = "~/.pyenv/versions/neovim/bin/python"

-----------------------------------------------------------
-- General
-----------------------------------------------------------
opt.mouse = "a" -- Enable mouse support
opt.clipboard = "unnamedplus" -- Copy/paste to system clipboard
opt.swapfile = false -- Don't use swapfile
opt.completeopt = "menuone,noinsert,noselect" -- Autocomplete options

-----------------------------------------------------------
-- Neovim UI
-----------------------------------------------------------
opt.number = true -- Show line number
opt.showmatch = true -- Highlight matching parenthesis
opt.foldmethod = "marker" -- Enable folding (default 'foldmarker')
-- opt.colorcolumn = "80" -- Line lenght marker at 80 columns
opt.cursorline = true
opt.splitright = true -- Vertical split to the right
opt.splitbelow = true -- Horizontal split to the bottom
opt.ignorecase = true -- Ignore case letters when search
opt.smartcase = true -- Ignore lowercase for the whole pattern
opt.linebreak = true -- Wrap on word boundary
opt.wrap = false -- do not wrap lines
opt.termguicolors = true -- Enable 24-bit RGB colors
opt.laststatus = 3 -- Set global statusline
opt.scrolloff = 5 -- leave 5 lines before and after cursor
opt.showtabline = 2

-----------------------------------------------------------
-- Tabs, indent
-----------------------------------------------------------
opt.expandtab = true -- Use spaces instead of tabs
opt.shiftwidth = 4 -- Shift 4 spaces when tab
opt.tabstop = 4 -- 1 tab == 4 spaces
opt.smartindent = true -- Autoindent new lines

-----------------------------------------------------------
-- Memory, CPU
-----------------------------------------------------------
opt.hidden = true -- Enable background buffers
opt.history = 100 -- Remember N lines in history
-- opt.lazyredraw = true -- Faster scrolling
opt.synmaxcol = 240 -- Max column for syntax highlight
opt.updatetime = 700 -- ms to wait for trigger an event

-----------------------------------------------------------
-- Undo, backup
-----------------------------------------------------------
opt.undofile = true
opt.swapfile = true
opt.backup = false

opt.undodir = { prefix .. "/nvim/undo//" }
opt.backupdir = { prefix .. "/nvim/backup//" }
opt.directory = { prefix .. "/nvim/swp//" }

-----------------------------------------------------------
-- Spelling
-----------------------------------------------------------

opt.spell = true
opt.spelllang = "en"
-----------------------------------------------------------
-- Startup
-----------------------------------------------------------

g.mapleader = config.leader_key
g.maplocalleader = config.local_leader_key
g.buffet_show_index = true

-- Disable nvim intro
opt.shortmess:append("sI")

-- Allow .nvimrc and .exrc
opt.exrc = true

-- Disable builtins plugins
local disabled_built_ins = {
    "2html_plugin",
    "getscript",
    "getscriptPlugin",
    "gzip",
    "logipat",
    "matchit",
    "tar",
    "tarPlugin",
    "rrhelper",
    "vimball",
    "vimballPlugin",
    "zip",
    "zipPlugin",
    "tutor",
    "rplugin",
    "syntax",
    "synmenu",
    "optwin",
    "compiler",
    "bugreport",
    "ftplugin",
}

for _, plugin in pairs(disabled_built_ins) do
    g["loaded_" .. plugin] = 1
end

local default_providers = {
    "node",
    "perl",
    "python3",
    "ruby",
}

for _, provider in ipairs(default_providers) do
    vim.g["loaded_" .. provider .. "_provider"] = 0
end

-- set shada path
vim.schedule(function()
    vim.opt.shadafile = vim.fn.expand("$HOME") .. "/.local/share/nvim/shada/main.shada"
    vim.cmd([[ silent! rsh ]])
end)
