return function()
    require("snacks").setup({
        picker = {
            enabled = true,
            ui_select = true,
            layout = {
                cycle = true,
            },
        },
    })
end
