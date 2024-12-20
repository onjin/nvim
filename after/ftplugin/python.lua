local set = vim.opt_local

set.shiftwidth = 4
set.expandtab = true

vim.keymap.set("n", "<space>t", ":lua require('utils.helpers').run_current_file_in_split 'python3'<CR>")
