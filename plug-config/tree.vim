
nnoremap <leader>ee :NvimTreeToggle<CR>
nnoremap <leader>er :NvimTreeRefresh<CR>
nnoremap <leader>ef :NvimTreeFindFile<CR>

" More available functions:
" NvimTreeOpen
" NvimTreeClose
" NvimTreeFocus
" NvimTreeFindFileToggle
" NvimTreeResize
" NvimTreeCollapse
" NvimTreeCollapseKeepBuffers

set termguicolors " this variable must be enabled for colors to be applied properly

" a list of groups can be found at `:help nvim_tree_highlight`
" highlight NvimTreeFolderIcon guibg=blue

lua <<EOF
require'nvim-tree'.setup {
    create_in_closed_folder = true,
    respect_buf_cwd = true,
    renderer = {
        highlight_git = true,
        highlight_opened_files = "none",
        root_folder_modifier = ':~',
        add_trailing = true,
        group_empty = true,
        special_files = { 'README.md', 'Makefile', 'MAKEFILE' },
        icons = {
            padding = ' ',
            symlink_arrow = ' >> ',
            show = {
                git = true,
                folder = false,
                file = false,
                folder_arrow = false,
            },
            glyphs = {
                 default = "",
                 symlink = "",
                 git = {
                     unstaged = "✗",
                     staged = "✓",
                     unmerged = "",
                     renamed = "➜",
                     untracked = "★",
                     deleted = "",
                     ignored = "◌"
                },
                 folder = {
                     arrow_open = "",
                     arrow_closed = "",
                     default = "",
                     open = "",
                     empty = "",
                     empty_open = "",
                     symlink = "",
                     symlink_open = "",
                }
            }
        }
    }
}
EOF
