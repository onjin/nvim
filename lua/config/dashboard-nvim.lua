local home = os.getenv('HOME')
local db = require('dashboard')

vim.g.dashboard_default_executive = 'telescope'

db.hide_tabline = true

db.preview_command = 'gh graph'
db.preview_file_path = ''
db.preview_file_height = 9
db.preview_file_width = 53

db.custom_center = {
    {icon = '  ',
    desc = 'Recently opened files                   ',
    action =  'Telescope frecency',
    shortcut = ', f h'},
    {icon = '  ',
    desc = 'Find  File                              ',
    action = 'Telescope find_files find_command=rg,--hidden,--files',
    shortcut = ', f f'},
    {icon = '  ',
    desc = 'Projects Browser                        ',
    action =  'Telescope project',
    shortcut = ', f p'},
    {icon = '  ',
    desc = 'File Browser                            ',
    action =  'Telescope file_browser',
    shortcut = ', f b'},
    {icon = '  ',
    desc = 'Find  word (grep)                       ',
    action = 'Telescope live_grep',
    shortcut = ', f r'},
    {icon = '  ',
    desc = 'Open Personal dotfiles                  ',
    action = 'Telescope file_browser path=' .. home ..'/dotfiles',
    shortcut = ', f d'},
    {icon = '  ',
    desc = 'Open vim config                         ',
    action = 'Telescope file_browser path=' .. home ..'/.vim/',
    shortcut = ', f v'},
}
