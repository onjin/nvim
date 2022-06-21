vim.o.background = "dark"

require('ayu').setup({
  overrides = {
    CurSearch = { bg = '#F1AE00' , fg = '#000000'},
    IncSearch = { bg = '#e92063' },
    NormalNC = {bg = '#0f151e', fg = '#808080'},
    CursorLine = { bg = "#2e2e2e" },
  }
})
vim.cmd('colorscheme ayu-dark')
