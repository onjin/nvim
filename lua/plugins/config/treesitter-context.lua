local setkey = require('utils').setkey

local M = {}
M.config = function()
    local mod = require("treesitter-context")
    local is_nvim_012 = vim.fn.has("nvim-0.12") == 1

    if is_nvim_012 then
        vim.schedule(function()
            vim.notify(
                "treesitter-context is disabled on Neovim 0.12 due to a plugin incompatibility",
                vim.log.levels.WARN,
                { title = "treesitter-context" }
            )
        end)
        return
    end

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
