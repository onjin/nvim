local setkey = require("utils").setkey

-- Auto insertmode in terminals
vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter" }, {
    pattern = { "*" },
    callback = function()
        if vim.opt.buftype:get() == "terminal" then
            vim.cmd(":startinsert")
        end
    end
})

-- Open terminals <leader>o...
setkey("n", "<leader>ot", function()
        vim.cmd.new()
        vim.cmd.wincmd "J"
        vim.api.nvim_win_set_height(0, 12)
        vim.wo.winfixheight = true
        vim.cmd.term()
    end,
    "Open bottom terminal"
)
-- Terminal mapping
setkey("t", "<esc><esc", "<c-\\><c-n>", "Easy <esc> in terminal")
