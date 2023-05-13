vim.opt.list = true

local function set_listchars(listchars)
    vim.opt.listchars:append("space:" .. listchars.space)
    vim.opt.listchars:append("tab:" .. listchars.tab)
    vim.opt.listchars:append("eol:" .. listchars.eol)
    vim.opt.listchars:append("trail:" .. listchars.trail)
    vim.opt.listchars:append("precedes:" .. listchars.precedes)
    vim.opt.listchars:append("extends:" .. listchars.extends)
end

local icons = require("onjin.icons")
local current_listchars = icons.default_listchars

local function indexOf(array, value)
    for i, v in ipairs(array) do
        if v == value then
            return i
        end
    end
    return nil
end

local function tablelength(T)
    local count = 0
    for _ in pairs(T) do
        count = count + 1
    end
    return count
end

local function cycle_listchars()
    local index = indexOf(icons.available_listchars, current_listchars)
    local length = tablelength(icons.available_listchars)
    if index + 1 > length then
        index = 1
    else
        index = index + 1
    end
    current_listchars = icons.available_listchars[index]
    set_listchars(current_listchars)
end

set_listchars(current_listchars)

return {
    {
        "lukas-reineke/indent-blankline.nvim",
        lazy = false,
        config = function()
            require("indent_blankline").setup({
                space_char_blankline = " ",
                show_current_context = true,
                show_current_context_start = true,
            })
            vim.api.nvim_create_user_command("CycleListchars", cycle_listchars, {})
            vim.keymap.set('n', '<leader>cl', function() vim.cmd('CycleListchars') end, { silent = true, nowait = true })
        end,
    },
}
