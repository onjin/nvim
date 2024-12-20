require "config.options"
require "config.commands"
require "config.keymaps"

-- set/override globals (vim.g) variables from ini file
require("utils.helpers").set_globals_from_ini ".nvimrc.ini"

--- initialize plugin manager
require "config.lazy"
