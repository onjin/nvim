vim.g.python_host_prog = "~/.pyenv/versions/neovim2/bin/python"
vim.g.python3_host_prog = "~/.pyenv/versions/neovim/bin/python"

require('config/options')
require('utils')
require("packer_init")
require('config/autocmds')
require('config/keymaps')
require('config/colors')
require('plugins')
