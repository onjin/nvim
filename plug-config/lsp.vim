if $LSP == 'native'

lua <<EOF
local lsp = require('lsp-zero')

lsp.preset('recommended')

local cmp_sources = require('lsp-zero.nvim-cmp-setup').sources()

lsp.setup_nvim_cmp({
    sources = {
        {name = 'path'},
        {name = 'nvim_lsp', keyword_length = 3},
        {name = 'buffer', keyword_length = 3},
        {name = 'luasnip', keyword_length = 2},
        {name = 'calc'},
        {name = 'copilot'},
        {name = 'emoji'},
        {name = 'tmux', option = {all_panes = true}},
    }
})

lsp.setup()

EOF

nnoremap <Leader>dn :lua vim.diagnostic.goto_next()<cr>
nnoremap <Leader>dp :lua vim.diagnostic.goto_prev()<cr>
nnoremap <Leader>dd :lua vim.diagnostic.setloclist()<cr>
" nnoremap <Leader>cf :lua vim.lsp.buf.formatting()<cr>
nnoremap <Leader>cf :Black<cr>

endif
