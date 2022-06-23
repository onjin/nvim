require'nvim-treesitter.configs'.setup {
    ensure_installed = {"python", "html", "javascript", "bash", "lua", "http", "json"},
    sync_install = false,
    ignore_install = { }, -- List of parsers to ignore installing
    highlight = {
        enable = true,              -- false will disable the whole extension
        disable = {}
    },
    indent = {
        enable = false,              -- false will disable the whole extension
        disale = {}
    },
}
-- set foldlevel=20
-- set foldmethod=expr
-- set foldexpr=nvim_treesitter#foldexpr()
