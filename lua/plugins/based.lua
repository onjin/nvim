-- plugin for quickly converting buffer text to/from hex.
-- bindings: ,ph
return {
    {
        "trmckay/based.nvim",
        opts = {
            highlight = "LspInlayHint",
        },
        lazy = true,
        cmd = "Based",
        config = function()
            vim.api.nvim_create_user_command("Based", require("based").convert, {})
        end,
    },
}
