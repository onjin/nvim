local home = os.getenv('HOME')
local db = require('dashboard')

vim.g.dashboard_default_executive = 'telescope'
db.custom_header = {
    "                                                           The Zen of Python, by Tim Peters                                                          ",
    "                                                                                                                                                     ",
    " - Beautiful is better than ugly.                                                - Explicit is better than implicit.                                 ",
    " - Simple is better than complex.                                                - Complex is better than complicated.                               ",
    " - Flat is better than nested.                                                   - Sparse is better than dense.                                      ",
    " - Readability counts.                                                           - Special cases aren't special enough to break the rules.           ",
    " - Although practicality beats purity.                                           - Errors should never pass silently.                                ",
    " - Unless explicitly silenced.                                                   - In the face of ambiguity, refuse the temptation to guess.         ",
    " - There should be one-- and preferably only one --obvious way to do it.         - Although that way may not be obvious at first unless you're Dutch.",
    " - Now is better than never.                                                     - Although never is often better than *right* now.                  ",
    " - If the implementation is hard to explain, it's a bad idea.                    - If the implementation is easy to explain, it may be a good idea.  ",
    " - Namespaces are one honking great idea -- let's do more of those!                                                                                  ",
    "                                                                                                                                                     ",
}

db.hide_tabline = true
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
    action = 'Telescope dotfiles path=' .. home ..'/dotfiles',
    shortcut = ', f d'},
    {icon = '  ',
    desc = 'Open vim config                         ',
    action = 'Telescope dotfiles path=' .. home ..'/.vim/',
    shortcut = ', f v'},
}
