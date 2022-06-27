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
map("n", "<Leader>ca", ":lua vim.lsp.buf.code_action()<cr>")

map('n', 'gd', '<cmd>lua require("telescope.builtin").lsp_definitions()<cr>')
map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')
map('n', 'gi', '<cmd>lua require("telescope.builtin").lsp_implementations()<cr>')
map('n', 'gt', '<cmd>lua require("telescope.builtin").lsp_type_definitions()<cr>')
map('n', 'gr', '<cmd>lua require("telescope.builtin").lsp_references()<cr>')
map('n', 'gn', '<cmd>lua require("cosmic-ui").rename()<cr>')

-- diagnostics
map('n', '[g', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
map('n', ']g', '<cmd>lua vim.diagnostic.goto_next()<cr>')
map('n', 'ge', '<cmd>lua vim.diagnostic.open_float(nil, { scope = "line", })<cr>')
map('n', '<leader>ce', '<cmd>Telescope diagnostics bufnr=0<cr>')

-- hover
map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')

-- code actions
map('n', '<leader>ca', '<cmd>lua require("cosmic-ui").code_actions()<cr>')
map('v', '<leader>ca', '<cmd>lua require("cosmic-ui").range_code_actions()<cr>')

-- formatting
map('n', '<leader>cf', '<cmd>lua vim.lsp.buf.formatting()<cr>')
map('v', '<leader>cf', '<cmd>lua vim.lsp.buf.range_formatting()<cr>')

-- signature help
-- clashes with ctrl-hjkl navigation
-- map('n', '<C-K>', '<cmd>lua require("lsp_signature").signature()<cr>')

-- lsp workspace
map('n', '<leader>wd', '<cmd>Telescope diagnostics<cr>')
map('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>')
map('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>')
