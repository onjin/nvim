return {
    {
        "luukvbaal/nnn.nvim",
        lazy = true,
        config = function()
            require("nnn").setup()
        end,
        cmd = { "NnnExplorer", "NnnPicker" },
    },
}
