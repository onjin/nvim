local M = {}
M.config = function()
    require("nvim-treesitter.configs").setup({
        auto_install = true,
        ensure_installed = { "lua", "vimdoc", "python", "java", "bash" },
        highlight = { enable = true },
    })

    vim.cmd("syntax off")

    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
end
return M
