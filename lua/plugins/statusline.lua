return {
    --[[{
        "nvim-lualine/lualine.nvim",
    },
    ]]
    {
        "linrongbin16/lsp-progress.nvim",
        event = { "VimEnter" },
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lsp-progress").setup()
        end,
    },
    {"rebelot/heirline.nvim"},
}
