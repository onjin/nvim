vim.o.background = "dark"

require('ayu').setup({
  overrides = {
    IncSearch = { fg = '#FFFFFF' },
    NormalNC = {bg = '#0f151e', fg = '#808080'}
  }
})
vim.cmd('colorscheme ayu-mirage')
