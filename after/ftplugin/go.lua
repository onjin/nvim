vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.keymap.set("n", "<space>t", ":lua require('utils').run_current_file_in_split 'go run'<CR>")
