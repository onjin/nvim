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

local mocha = require("catppuccin.palettes").get_palette "mocha"
-- mini.tabline
vim.api.nvim_set_hl(0, "MiniTablineCurrent", { bg = mocha.surface2, fg = mocha.pink })
vim.api.nvim_set_hl(0, "MiniTablineModifiedCurrent", { bg = mocha.surface2, fg = mocha.red })

vim.api.nvim_set_hl(0, "MiniTablineVisible", { bg = mocha.base, fg = mocha.text })
vim.api.nvim_set_hl(0, "MiniTablineModifiedVisible", { bg = mocha.base, fg = mocha.red })

vim.api.nvim_set_hl(0, "MiniTablineHidden", { bg = mocha.crust, fg = mocha.overlay1 })
vim.api.nvim_set_hl(0, "MiniTablineModifiedHidden", { bg = mocha.crust, fg = mocha.red })

-- nvim-cmp
vim.api.nvim_set_hl(0, "CmpCursorLine", { bg = mocha.base, fg = mocha.pink })
