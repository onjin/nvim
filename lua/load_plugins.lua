local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=main",
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  checker = {
    enabled = true,
    frequency = 3600,
  },

  -- Git related plugins
  "tpope/vim-fugitive",
  "tpope/vim-rhubarb",

  -- Detect tabstop and shiftwidth automatically
  "tpope/vim-sleuth",

  {
    "dstein64/vim-startuptime",
    lazy = true,
    event = "VeryLazy",
  },

  -- devicons
  "nvim-tree/nvim-web-devicons",

  -- Neovim plugin to improve the default vim.ui interfaces
  "stevearc/dressing.nvim",

  {
    "AckslD/nvim-neoclip.lua",
    dependencies = { "kkharji/sqlite.lua", module = "sqlite" },
    config = function()
      require("neoclip").setup()
    end,
    lazy = true,
    event = "VeryLazy",
  },

  -- bufdelete (used to open dash when all buffers are closed)
  "famiu/bufdelete.nvim",

  -- surround
  "tpope/vim-surround",

  -- import built in plugins from lua/plugins/*
  { import = "plugins" },

  -- to add your own plugins, fork repo or usa lua/custom/plugins/* (loaded later)
  { import = "custom.plugins" },
}, {
  -- Options
  -- colorscheme = { "minimus" },
  ui = {
    -- a number <1 is a percentage., >1 is a fixed size
    size = { width = 0.8, height = 0.8 },
    wrap = false, -- wrap the lines in the ui
    -- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
    border = "rounded",
  },
  -- defaults = {
  -- 	cond = os.getenv("NVIM") == nil,
  -- },
})
