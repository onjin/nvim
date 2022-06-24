require 'nvim-treesitter.configs'.setup {
  ensure_installed = {
    "bash",
    "comment",
    "css",
    "html",
    "http",
    "javascript",
    "json",
    "lua",
    "make",
    "markdown",
    "python",
    "regex",
    "scheme",
    "toml",
    "yaml",
  },

  sync_install = false,
  ignore_install = {}, -- List of parsers to ignore installing
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = {}
  },
  indent = {
    enable = true, -- false will disable the whole extension
    disale = {}
  },
}
vim.cmd([[set foldmethod=expr]])
vim.cmd([[set foldexpr=nvim_treesitter#foldexpr()]])
-- set foldlevel=20
-- set foldmethod=expr
-- set foldexpr=nvim_treesitter#foldexpr()
