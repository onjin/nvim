local MiniPick = require('mini.pick')
local MiniExtra = require('mini.extra')

-- Use mini.pick as the default selector in vim
vim.ui.select = MiniPick.ui_select

vim.keymap.set("n", "<leader>sf", MiniPick.builtin.files, { noremap = true, desc = "Search files" })
vim.keymap.set("n", "<leader>sb", MiniPick.builtin.buffers, { noremap = true, desc = 'Search buffers' })
vim.keymap.set("n", "<leader>sg", MiniPick.builtin.grep_live, { noremap = true, desc = 'Search live grep' })
vim.keymap.set("n", "<leader>s*", "<cmd>Pick grep pattern='<cword>'<cr>", { desc = "Grep string under cursor" })

-- Mappings
vim.keymap.set("n", "<Leader>fk", MiniExtra.pickers.keymaps, { desc = "Find keymaps" })
vim.keymap.set("n", "<Leader>fc", MiniExtra.pickers.commands, { desc = "Find commands" })
vim.keymap.set("n", "<leader>fs", MiniExtra.pickers.spellsuggest, { desc = "Find spelling" })
