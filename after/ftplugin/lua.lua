local set = vim.opt_local

set.shiftwidth = 3
set.expandtab = true

vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>", { desc = "[X] Source file" })
vim.keymap.set("n", "<space>x", ":.lua<CR>", { desc = "[X] Run with lua" })
vim.keymap.set("v", "<space>x", ":lua<CR>", { desc = "[X] Run with lua" })
vim.keymap.set("n", "<space>t", ":lua require('utils.helpers').run_current_file_in_split 'lua'<CR>")
