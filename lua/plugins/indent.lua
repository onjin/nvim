local config = require("onjin.config")

vim.opt.list = config.listchars

local function set_listchars(listchars)
    vim.opt.listchars:append("space:" .. listchars.space)
    vim.opt.listchars:append("tab:" .. listchars.tab)
    vim.opt.listchars:append("eol:" .. listchars.eol)
    vim.opt.listchars:append("trail:" .. listchars.trail)
    vim.opt.listchars:append("precedes:" .. listchars.precedes)
    vim.opt.listchars:append("extends:" .. listchars.extends)
end

local icons = require("onjin.icons")
local utils = require("utils")
local current_listchars = icons.available_listchars[config.listchars_theme_number]

local function cycle_listchars()
    local index = utils.indexOf(icons.available_listchars, current_listchars)
    local length = utils.tablelength(icons.available_listchars)
    if index + 1 > length then
        index = 1
    else
        index = index + 1
    end
    current_listchars = icons.available_listchars[index]
    set_listchars(current_listchars)
end

set_listchars(current_listchars)
vim.api.nvim_create_user_command("CycleListchars", cycle_listchars, {})

vim.opt.termguicolors = true

vim.cmd([[highlight IndentBlanklineIndent1 guibg=#1e1e2e  gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent2 guibg=#1b1b2b gui=nocombine]])

return {
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        lazy = false,
        config = function()
            require("ibl").setup({
                whitespace = {
                    remove_blankline_trail = false,
                },
                scope = { enabled = true },
            })
        end,
    },
}
