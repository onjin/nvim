-- load options first
require 'config.options'

-- allow per-project overrides via .nvimrc.ini
require("nvimrc").setup({ debug = false })

-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup(require("plugins.spec"), {
    ui = { border = "rounded" },
    checker = { enabled = false },
})

vim.cmd.colorscheme(vim.g.colorscheme)

-- load other static config
require 'config.terminal'
