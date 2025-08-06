local set = vim.opt_local

set.shiftwidth = 3
set.expandtab = true

vim.keymap.set("n", "<localleader><localleader>x", "<cmd>source %<CR>", { desc = "[X] Source file" })
vim.keymap.set("n", "<localleader>x", ":.lua<CR>", { desc = "[X] Run with lua" })
vim.keymap.set("v", "<localleader>x", ":lua<CR>", { desc = "[X] Run with lua" })
vim.keymap.set("n", "<localleader>t", ":lua require('utils.helpers').run_current_file_in_split 'lua'<CR>")
