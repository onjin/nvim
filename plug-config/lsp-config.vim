" LSP config (the mappings used in the default file don't quite work right)
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <C-s> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> [d <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> ]d <cmd>lua vim.lsp.diagnostic.goto_next()<CR>

nnoremap <silent> <space>wa <cmd>lua vim.lsp.buf.add_workspace_folder()<CR>
nnoremap <silent> <space>wr <cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>
nnoremap <silent> <space>wl <cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>
nnoremap <silent> <space>D <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> <space>rn <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> <space>a <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> <space>e <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
nnoremap <silent> <space>q <cmd>lua vim.lsp.diagnostic.set_loclist()<CR>
nnoremap <silent> <space>f <cmd>lua vim.lsp.buf.formatting()<CR>

hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
augroup lsp_document_highlight
  autocmd! * <buffer>
  autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
  autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
augroup END

" auto-format
autocmd BufWritePre *.js lua vim.lsp.buf.formatting(nil, 100)
autocmd BufWritePre *.jsx lua vim.lsp.buf.formatting(nil, 100)
"autocmd BufWritePre *.py lua vim.lsp.buf.formatting(nil, 100)


