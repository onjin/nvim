local function set(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { desc = desc, noremap = true, silent = true })
end

local MiniPick = require('mini.pick')
local MiniExtra = require('mini.extra')

-- Use mini.pick as the default selector in vim
vim.ui.select = MiniPick.ui_select

-- Simple windows navigation, same set in tmux
set("n", "<c-h>", "<c-w><c-h>", "Switch split left")
set("n", "<c-j>", "<c-w><c-j>", "Switch split down")
set("n", "<c-k>", "<c-w><c-k>", "Switch split up")
set("n", "<c-l>", "<c-w><c-l>", "Switch split right")

-- Utilities
set("n", "<C-/>", function() if vim.opt.hlsearch then vim.cmd.nohl() end end, "Toggle of hlsearch")

-- Files search <leaders>s...
set("n", "<leader>sf", '<cmd>Pick files<cr>', "Search files")
set("n", "<leader>sb", MiniPick.builtin.buffers, "Search buffers")
set("n", "<leader>sg", "<cmd>Pick grep_live tool='git'<cr>", 'Search live git grep')
set("n", "<leader>sG", "<cmd>Pick grep_live tool='rg'<cr>", 'Search live ripgrep')
set("n", "<leader>s*", "<cmd>Pick grep pattern='<cword>'<cr>", "Grep string under cursor")

-- Find some elements <leader>f...
set("n", "<Leader>fk", MiniExtra.pickers.keymaps, "Find keymaps")
set("n", "<Leader>fc", MiniExtra.pickers.commands, "Find commands")
set("n", "<leader>fs", MiniExtra.pickers.spellsuggest, "Find spelling")

-- Toggles <leader>t...
set("n", "<leader>tD", function()
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
set("n", "<leader>td", function()
        local current_value = vim.diagnostc.config().virtual_text
        if current_value then
            vim.diagnosci.config { virftual_text = false }
            vim.notify("[toggle] Virtual diagnostic disabled")
        else
            vim.diagnosci.config { virftual_text = true }
            vim.notify("[toggle] Virtual diagnostic disabled")
        end
    end,
    "Toggle Virtual diagnostics"
)
set("n", "<leader>tm", function()
        vim.o.scrollof = 9999 - vim.o.scrollof
    end,
    "Toggle middle line focus"
)
