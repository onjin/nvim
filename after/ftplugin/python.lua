local set = vim.opt_local

set.shiftwidth = 4
set.expandtab = true

vim.keymap.set("n", "<space>t", ":lua require('utils.helpers').run_current_file_in_split 'python3'<CR>")
-- 1) fold by indent - the treesitter exspression is messing with fold when I'm removing [" chars
vim.opt_local.foldmethod = "indent"

-- 2) when you open the file, only fold top-level defs/classes
--    (indent level 1 in Python is inside your def/class)
vim.opt_local.foldlevelstart = 1
vim.opt_local.foldlevel = 1

-- 3) nice defaults so you don’t fold tiny one-liners
vim.opt_local.foldminlines = 3 -- at least 3 lines to make a fold
vim.opt_local.foldnestmax = 3 -- no more than 3 levels deep

-- 4) keep folding turned on
vim.opt_local.foldenable = true
