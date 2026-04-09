local pack = require "plugins.pack"

vim.g.mapleader = ","
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.colorcolumn = "120"
vim.opt.textwidth = 120
vim.opt.swapfile = false
vim.opt.confirm = true
vim.opt.linebreak = true
vim.opt.termguicolors = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.completeopt = "menuone,fuzzy,popup,noinsert,noselect"
vim.opt.complete = "o,.,w,b,u"
vim.opt.autocomplete = false
vim.opt.grepprg = "rg --vimgrep --no-messages --smart-case"
vim.opt.smoothscroll = true
vim.opt.wildoptions:append { "fuzzy" }
vim.opt.path:append { "**" }

pack.add {
  { src = "https://github.com/nvim-lua/plenary.nvim" },
}

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})
