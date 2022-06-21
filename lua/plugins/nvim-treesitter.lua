require'nvim-treesitter.configs'.setup {
    ensure_installed = {"python", "html", "javascript", "bash", "lua"},
    sync_insatll = false,
    ignore_install = { }, -- List of parsers to ignore installing
    highlight = {
        enable = true,              -- false will disable the whole extension
    },
    indent = {
        enable = false,              -- false will disable the whole extension
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
        },
    },
}
-- set foldlevel=20
-- set foldmethod=expr
-- set foldexpr=nvim_treesitter#foldexpr()
