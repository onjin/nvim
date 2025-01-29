require "config.options"
require "config.commands"
require "config.keymaps"

-- set/override globals (vim.g) variables from ini file
require("nvimrc").setup()

--- initialize plugin manager
require "config.lazy"

vim.cmd.colorscheme(vim.g.colorscheme)
