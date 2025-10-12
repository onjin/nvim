vim.g.mapleader = ","
vim.g.maplocalleader = " "

--(S)Ex
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 4
vim.g.netrw_altv = 1
vim.g.netrw_winsize = 25
vim.g.buffet_show_index = true


-- load plugins specification & engine
local spec = require("plugins.spec")
local engine = require("plugins.engine")

engine.execute("mini-deps", spec) -- mini-deps, lazy, builtin (experimental)
