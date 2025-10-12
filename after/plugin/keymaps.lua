local setkey = require('utils').setkey

local MiniPick = require('mini.pick')
local MiniExtra = require('mini.extra')

-- Use mini.pick as the default selector in vim
vim.ui.select = MiniPick.ui_select

-- Simple windows navigation, same set in tmux
setkey("n", "<c-h>", "<c-w><c-h>", "Switch split left")
setkey("n", "<c-j>", "<c-w><c-j>", "Switch split down")
setkey("n", "<c-k>", "<c-w><c-k>", "Switch split up")
setkey("n", "<c-l>", "<c-w><c-l>", "Switch split right")

-- Utilities
setkey("n", "<C-/>", function() if vim.opt.hlsearch then vim.cmd.nohl() end end, "Toggle of hlsearch")

-- Files search <leaders>s...
setkey("n", "<leader>sf", '<cmd>Pick files<cr>', "Search files")
setkey("n", "<leader>sb", MiniPick.builtin.buffers, "Search buffers")
setkey("n", "<leader>sg", "<cmd>Pick grep_live tool='git'<cr>", 'Search live git grep')
setkey("n", "<leader>sG", "<cmd>Pick grep_live tool='rg'<cr>", 'Search live ripgrep')
setkey("n", "<leader>s*", "<cmd>Pick grep pattern='<cword>'<cr>", "Grep string under cursor")

-- Find some elements <leader>f...
setkey("n", "<Leader>fk", MiniExtra.pickers.keymaps, "Find keymaps")
setkey("n", "<Leader>fc", MiniExtra.pickers.commands, "Find commands")
setkey("n", "<leader>fs", MiniExtra.pickers.spellsuggest, "Find spelling")

-- Toggles <leader>t...
setkey("n", "<leader>tD", function()
        if vim.diagnostic.is_enabled() then
            vim.diagnostic.enable(false)
            vim.notify("[toggle] Diagnostics disabled")
        else
            vim.diagnostic.enable(true)
            vim.notify("[toggle] Diagnostics enabled")
        end
    end,
    "Toggle Diagnostics"
)
setkey("n", "<leader>td", function()
        local current_value = vim.diagnostic.config().virtual_text
        if current_value then
            vim.diagnostic.config { virftual_text = false }
            vim.notify("[toggle] Virtual diagnostic disabled")
        else
            vim.diagnostic.config { virftual_text = true }
            vim.notify("[toggle] Virtual diagnostic disabled")
        end
    end,
    "Toggle Virtual diagnostics"
)
setkey("n", "<leader>tm", function()
        vim.o.scrollof = 9999 - vim.o.scrollof
    end,
    "Toggle middle line focus"
)
