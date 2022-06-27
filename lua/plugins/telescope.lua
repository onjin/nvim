local home = os.getenv('HOME')

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
    file_browser = {
      theme = "ivy",
      hijack_netrw = true,
    },
     project = {
          base_dirs = {
            {'~/Workspace/src', max_depth = 4},
          },
          display_type  = 'full', -- or 'minimal'
          hidden_files = true, -- default: false
          -- theme = "dropdown"
    }
}}
require('telescope').load_extension('file_browser')
require('telescope').load_extension('frecency')
require('telescope').load_extension('fzf')
require('telescope').load_extension('gh')
require('telescope').load_extension('media_files')
require'telescope'.load_extension('project')
require'telescope'.load_extension'repo'

local map = require("utils").map

map("n", "<Leader>b", "<cmd>Telescope buffers<cr>")
map("n", "<Leader>B", "<cmd>Telescope current_buffer_tags<cr>")

map("n", "<Leader>fb", "<cmd>Telescope file_browser<cr>")
map("n", "<Leader>fd", "<cmd>Telescope file_browser path=" .. home .. "/dotfiles<cr>")
map("n", "<Leader>fv", "<cmd>Telescope file_browser path=" .. home .. "/.vim/<cr>")
map("n", "<Leader>fg", "<cmd>Telescope git_files show_ungracked=false<cr>")
map("n", "<Leader>ff", "<cmd>Telescope find_files find_command=rg,--hidden,--files<cr>")

-- do not map F - it's used to find backward
-- map("") <Leader>fr :lua args = {'rg','--color=never','--no-heading','--with-filename','--line-number','--column','--smart-case'} table.insert(args, vim.fn.input('rg > ')) require('telescope.builtin').live_grep( { vimgrep_arguments = args} )<CR>
map("n", "<Leader>fr", "<cmd>Telescope live_grep<cr>")
map("n", "<Leader>ft", "<cmd>Telescope tags<cr>")
map("n", "<Leader>fc", "<cmd>Telescope colorscheme<cr>")

map("n", "<Leader>fh", "<cmd>Telescope frecency<cr>")

map("n", "<C-p>", "<cmd>Telescope git_files show_untracked=false<cr>")
map("n", "<leader>fp", "<cmd>Telescope project<cr>")
