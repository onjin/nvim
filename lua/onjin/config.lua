local M = {}

-- colorscheme
M.theme = 'catppuccin'

-- for catppuccin theme you can set flavour latte, frappe, macchiato, mocha
M.theme_flavour = "mocha"

-- show spaces/new lines/etc
M.listchars = true

-- 1 - Symbols " ␋␤␠«»"
-- 2 - Fancy   " ▸¬●«»"
-- 3 - Plain   " >-$~<>"
-- mappings: <leader>cl - cycle listchars theme
-- configure: lua/onjin/icons.lua:availble_listchars
M.listchars_theme_number = 2

return M
