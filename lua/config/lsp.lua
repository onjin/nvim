local lsp = require('lsp-zero')

lsp.preset('recommended')

local cmp_sources = require('lsp-zero.nvim-cmp-setup').sources()

lsp.setup_nvim_cmp({
    sources = {
        {name = 'path'},
        {name = 'nvim_lsp', keyword_length = 2},
        {name = 'buffer', keyword_length = 3},
        {name = 'luasnip', keyword_length = 2},
        {name = 'calc'},
        -- {name = 'copilot'},
        {name = 'emoji'},
        -- {name = 'tmux', option = {all_panes = true}},
    }
})

lsp.setup()

local map = require("utils").map

map("n", "<Leader>b", "<cmd>Telescope buffers<cr>")

map("n", "<Leader>dn", ":lua vim.diagnostic.goto_next()<cr>")
map("n", "<Leader>dp", ":lua vim.diagnostic.goto_prev()<cr>")
map("n", "<Leader>dd", ":lua vim.diagnostic.setloclist()<cr>")
map("n", "<Leader>cf", ":Black<cr>")
