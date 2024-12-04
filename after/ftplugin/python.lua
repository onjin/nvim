vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.keymap.set("n", "<space>t", ":lua require('utils').run_current_file_in_split 'python3'<CR>")
