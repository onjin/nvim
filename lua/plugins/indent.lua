vim.opt.list = true

local icons = require('onjin.icons')

vim.opt.listchars:append ("space:" .. icons.listchars.space)
vim.opt.listchars:append ("tab:" .. icons.listchars.tab)
vim.opt.listchars:append ("eol:" .. icons.listchars.eol)
vim.opt.listchars:append ("trail:" .. icons.listchars.trail)
vim.opt.listchars:append ("precedes:" .. icons.listchars.precedes)
vim.opt.listchars:append ("extends:" .. icons.listchars.extends)


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
        end,
    },
}
