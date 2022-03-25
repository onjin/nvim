if $LSP == 'native'

lua <<EOF
local lsp = require('lsp-zero')

lsp.preset('recommended')
lsp.setup()

EOF

nnoremap <Leader>dn :lua vim.diagnostic.goto_next()<cr>
nnoremap <Leader>dp :lua vim.diagnostic.goto_prev()<cr>
nnoremap <Leader>dd :lua vim.diagnostic.setloclist()<cr>
nnoremap <Leader>cf :lua vim.lsp.buf.formatting()<cr>

endif
