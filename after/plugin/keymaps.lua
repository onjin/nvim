local function set(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { desc = desc, noremap = true })
end

local MiniPick = require('mini.pick')
local MiniExtra = require('mini.extra')

-- Use mini.pick as the default selector in vim
vim.ui.select = MiniPick.ui_select

-- Simple windows navigation, same set in tmux
set("n", "<c-h>", "<c-w><c-h>", "Swith split left")
set("n", "<c-j>", "<c-w><c-j>", "Swith split down")
set("n", "<c-k>", "<c-w><c-k>", "Swith split up")
set("n", "<c-l>", "<c-w><c-l>", "Swith split right")

-- Files search
set("n", "<leader>sf", '<cmd>Pick files<cr>', "Search files")
set("n", "<leader>sb", MiniPick.builtin.buffers, "Search buffers")
set("n", "<leader>sg", "<cmd>Pick grep_live tool='git'<cr>", 'Search live git grep')
set("n", "<leader>sG", "<cmd>Pick grep_live tool='rg'<cr>", 'Search live ripgrep')
set("n", "<leader>s*", "<cmd>Pick grep pattern='<cword>'<cr>", "Grep string under cursor")

-- Find some elements
set("n", "<Leader>fk", MiniExtra.pickers.keymaps, "Find keymaps")
set("n", "<Leader>fc", MiniExtra.pickers.commands, "Find commands")
set("n", "<leader>fs", MiniExtra.pickers.spellsuggest, "Find spelling")
