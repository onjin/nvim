vim.opt.list = true
vim.opt.listchars:append "space: "
vim.opt.listchars:append "tab:▸ "
vim.opt.listchars:append "eol:¬"
vim.opt.listchars:append "trail:●"
vim.opt.listchars:append "precedes:«"
vim.opt.listchars:append "extends:»"

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
