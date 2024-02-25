-- luacheck: globals vim
local config = require("config")

if config.theme == "catppuccin" then
    local catppuccin = require("catppuccin")

    local options = {
        compile = {
            enabled = true,
            path = vim.fn.stdpath("cache") .. "/catppuccin",
        },
    }
    vim.g.catppuccin_flavour = config.theme_flavour

    catppuccin.setup(options)
end

local theme = config.theme

local cmd = string.format("colorscheme %s", theme)
vim.cmd(cmd)
