local opt = vim.opt
local state_prefix = vim.env.XDG_STATE_HOME or vim.fn.expand "~/.local/state"

-- default mapleader
vim.g.mapleader = ","

-- whether enable remote AI plugins - my not be allowed in certain projects
-- use .nvimrc.ini to set it per project
vim.g.ai_enabled = 0

-- default colorscheme
vim.g.colorscheme = "catppuccin-mocha"

-- whether run autoformat on save
-- use .nvimrc.ini to set it per project
vim.g.autoformat_on_save_enabled = 0

vim.g.lsp_servers_ensure_installed = { "lua_ls" }
vim.g.lsp_disable_semantic_tokens = {
  lua = true,
} -- disable semanticTokensProvider for filetype

vim.g.treesitter_ensure_installed = {
  "bash",
  "c",
  "diff",
  "html",
  "lua",
  "luadoc",
  "markdown",
  "markdown_inline",
  "query",
  "vim",
  "vimdoc",
}

----- Interesting Options -----

-- You have to turn this one on :)
opt.inccommand = "split"

-- Best search settings :)
opt.smartcase = true
opt.ignorecase = true

----- Personal Preferences -----
opt.number = true
opt.relativenumber = true

opt.splitbelow = true
opt.splitright = true

-- Keep signcolumn on by default
opt.signcolumn = "yes"
opt.shada = { "'10", "<0", "s10", "h" }

opt.clipboard = "unnamedplus"

-- Don't have `o` add a comment
opt.formatoptions:remove "o"

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = "a"

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- buffers list as tab, and context
vim.opt.showtabline = 2

vim.g.buffet_show_index = true

-- Disable nvim intro
vim.opt.shortmess:append "sI"

-- Allow .nvimrc and .exrc
vim.opt.exrc = true
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

opt.undodir = { state_prefix .. "/nvim/undo//" }
opt.backupdir = { state_prefix .. "/nvim/backup//" }
opt.directory = { state_prefix .. "/nvim/swp//" }

-----------------------------------------------------------
-- Spelling
-----------------------------------------------------------

opt.spell = true
opt.spelllang = "en"

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
  vim.g["loaded_" .. plugin] = 1
end

vim.filetype.add {
  extensions = {
    cheat = "navi",
  },
}
