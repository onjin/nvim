local M = {}
M.config = function()
    require("nvim-treesitter.configs").setup({
        auto_install = true,
        ensure_installed = {
            "bash",
            "diff",
            "html",
            "java",
            "lua",
            "luadoc",
            "markdown",
            "markdown_inline",
            "python",
            "query",
            "vim",
            "vimdoc",
        },
        highlight = { enable = true },
    })

    vim.cmd("syntax off")

    local opt = vim.opt
    opt.foldmethod = "expr"
    opt.foldexpr = "nvim_treesitter#foldexpr()"
    opt.foldenable = true
    opt.foldlevel = 99
    opt.foldlevelstart = 99

    local fallback_group = vim.api.nvim_create_augroup("config_treesitter_folds", { clear = true })
    vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufWinEnter" }, {
        group = fallback_group,
        callback = function(args)
            local bo = vim.bo[args.buf]
            if bo.buftype ~= "" then return end
            local ok = pcall(vim.treesitter.get_parser, args.buf)
            if ok then
                vim.opt_local.foldmethod = "expr"
                vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
            else
                vim.opt_local.foldmethod = "indent"
                vim.opt_local.foldexpr = ""
            end
        end,
        desc = "Fallback to indent folding when treesitter parser is unavailable",
    })
end
return M
