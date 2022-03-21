if $FUZZY_FINDER == 'telescope'
    " Find files using Telescope command-line sugar.
    "nnoremap <leader>ff <cmd>Telescope find_files<cr>
    "nnoremap <leader>fg <cmd>Telescope live_grep<cr>
    "nnoremap <leader>fb <cmd>Telescope buffers<cr>
    "nnoremap <leader>fh <cmd>Telescope help_tags<cr>
    "
    noremap <Leader>b <cmd>Telescope buffers<cr>
    noremap <Leader>B <cmd>Telescope current_buffer_tags<cr>

    noremap <C-p> <cmd>Telescope git_files show_untracked=false<cr>
    noremap <Leader>fg <cmd>Telescope git_files show_ungracked=false<cr>
    " do not map F - it's used to find backward

    "noremap <Leader>fr :lua args = {'rg','--color=never','--no-heading','--with-filename','--line-number','--column','--smart-case'} table.insert(args, vim.fn.input('rg > ')) require('telescope.builtin').live_grep( { vimgrep_arguments = args} )<CR>
    noremap <Leader>fr <cmd>Telescope live_grep<cr>
    noremap <Leader>ft <cmd>Telescope tags<cr>

lua << END
    require('telescope').setup{
        defaults = {
            -- Default configuration for telescope goes here:
            -- config_key = value,
            file_sorter =  require'telescope.sorters'.get_fzy_sorter,
            generic_sorter =  require'telescope.sorters'.get_fzy_sorter,
            mappings = {
            i = {
                -- map actions.which_key to <C-h> (default: <C-/>)
                -- actions.which_key shows the mappings for your picker,
                -- e.g. git_{create, delete, ...}_branch for the git_branches picker
                ["<C-h>"] = "which_key"
            }
            }
        },
        pickers = {
            -- Default configuration for builtin pickers goes here:
            -- picker_name = {
            --   picker_config_key = value,
            --   ...
            -- }
            -- Now the picker_config_key will be applied every time you call this
            -- builtin picker
        },
        extensions = {
            -- Your extension configuration goes here:
            -- extension_name = {
            --   extension_config_key = value,
            -- }
            -- please take a look at the readme of the extension you want to configure
        }
    }
    require('telescope').load_extension('fzf')
    require('telescope').load_extension('media_files')
    require('telescope').load_extension('gh')
    require('telescope').load_extension('coc')
END
endif
