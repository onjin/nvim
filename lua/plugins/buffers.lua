vim.g.close_buffers_bdelete_command = "BClose"
vim.g.close_buffers_bwipeout_command = "BCloseAll"

return {
    {
        "Asheq/close-buffers.vim",
    },
    {
        "axkirillov/hbac.nvim",
        config = function()
            require("hbac").setup()
        end,
    },
}
