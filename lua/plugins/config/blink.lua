return function()
    local blink = require("blink.cmp")
    blink.setup({
        keymap = {
            preset = "super-tab",
        },
    })

    if blink.loaders and blink.loaders.from_vscode and blink.loaders.from_vscode.lazy_load then
        blink.loaders.from_vscode.lazy_load()
    end
end
