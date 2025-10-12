local setkey = require('utils').setkey

local M = {}
M.config = function()
    local mod = require("treesitter-context");
    mod.setup()

    setkey("n", "<leader>jc", function()
            mod.go_to_context(vim.v.count1)
        end,
        "Jump to current context"
    )
    setkey("n", "<leader>tc", function()
            mod.toggle()
        end,
        "Toggle treesitter context"
    )
    setkey("n", "<leader>tC", function()
            mod.toggle()
        end,
        "Toggle treesitter context"
    )
    setkey("n", "<leader>tc", function()
            require("nvim_context_vt").toggle_context()
        end,
        "Toggle virtual context"
    )
end
return M
