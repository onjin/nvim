-- luacheck: globals vim

local catppuccin = require "catppuccin"

local options = {
  compile = {
    enabled = true,
    path = vim.fn.stdpath "cache" .. "/catppuccin",
  },
}
vim.g.catppuccin_flavour = "mocha"

catppuccin.setup(options)
vim.cmd "colorscheme catppuccin"
