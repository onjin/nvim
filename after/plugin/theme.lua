-- luacheck: globals vim

local catppuccin = require "catppuccin"

local options = {
   compile = {
      enabled = true,
      path = vim.fn.stdpath "cache" .. "/catppuccin",
   },
   integrations = {
      cmp = true,
      gitsigns = true,
      nvimtree = true,
      treesitter = true,
      notify = true,
      mini = {
         enabled = true,
         indentscope_color = "",
      },
   }
}
vim.g.catppuccin_flavour = "mocha"

catppuccin.setup(options)
vim.cmd "colorscheme catppuccin"
