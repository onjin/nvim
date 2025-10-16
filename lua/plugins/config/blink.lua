return function()
    local blink = require("blink.cmp")
    blink.setup({
        keymap = {
            preset = "super-tab",
            ["<C-y>"] = { "select_and_accept", "fallback" },
            ["<C-x><C-o>"] = {
                function(cmp)
                    return cmp.show({ providers = { "lsp" } })
                end,
            },
        },
    })

    if blink.loaders and blink.loaders.from_vscode and blink.loaders.from_vscode.lazy_load then
        blink.loaders.from_vscode.lazy_load()
    end
end
