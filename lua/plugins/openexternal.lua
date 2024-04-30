return {
    "chrishrb/gx.nvim",
    keys = { { "gx", "<cmd>Browse<cr", mode = { "n", "x" } } },
    cms = { "Browse" },
    init = function()
        vim.g.netrw_nogx = 1
    end,
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true,
    submodules = false,
}
