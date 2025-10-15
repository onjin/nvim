vim.g.mapleader = ","
vim.g.maplocalleader = " "

--(S)Ex
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 4
vim.g.netrw_altv = 1
vim.g.netrw_winsize = 25
vim.g.buffet_show_index = true


local opt = vim.opt
local state_prefix = vim.env.XDG_STATE_HOME or vim.fn.expand "~/.local/state"

-- base spaces/tabs if not set
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4

-- theme
vim.o.background = "dark"

-- fuzzy search by :find text<tab>
vim.opt.path:append "**"


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

-- Do not update diagnostics in Insert mode - it causes many weird not real/outdated diagnostics
vim.diagnostic.config({
    update_in_insert = false,
})

-- Disable nvim intro
vim.opt.shortmess:append "sI"

-- Allow .nvimrc and .exrc
vim.opt.exrc = true
-----------------------------------------------------------
-- Memory, CPU
-----------------------------------------------------------
opt.hidden = true    -- Enable background buffers
opt.history = 100    -- Remember N lines in history
-- opt.lazyredraw = true -- Faster scrolling
opt.synmaxcol = 240  -- Max column for syntax highlight
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
-- Folding
-----------------------------------------------------------
-- keep folds open by default; treesitter config upgrades the method when available
opt.foldmethod = "indent"
opt.foldexpr = ""
opt.foldenable = true
opt.foldcolumn = "auto:1"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldminlines = 1
opt.foldnestmax = 6

-----------------------------------------------------------
-- Spelling
-----------------------------------------------------------

opt.spell = false
opt.spelllang = "en"

vim.filetype.add {
    extensions = {
        cheat = "navi",
    },
}
