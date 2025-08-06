vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
vim.keymap.set("n", "<localleader>t", ":lua require('utils.helpers').run_current_file_in_split 'go run'<CR>")
