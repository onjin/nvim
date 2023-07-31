return {
    {
        "ethanholz/nvim-lastplace",
        config = function()
            local opts = {
                lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
                lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
                lastplace_open_folds = true,
            }
            require("nvim-lastplace").setup(opts)
        end,
    },
    { "editorconfig/editorconfig-vim" },
}
