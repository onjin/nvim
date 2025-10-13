local setkey = require('utils').setkey

local M = {}
M.config = function()
    local harpoon = require "harpoon"
    harpoon:setup()
    vim.keymap.set("n", "<m-h><m-l>", function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
        --harpoon.ui:toggle_quick_menu(harpoon:list())
    end)
    vim.keymap.set("n", "<m-h><m-m>", function()
        harpoon:list():add()
    end)

    vim.keymap.set("n", "<m-p>", function()
        harpoon:list():prev()
    end, { desc = "Harpoon [P]rev" })
    vim.keymap.set("n", "<m-n>", function()
        harpoon:list():next()
    end, { desc = "Harpoon [N]ext" })

    -- Set <space>1..<space>5 be my shortcuts to moving to the files
    for _, idx in ipairs { 1, 2, 3, 4, 5 } do
        vim.keymap.set("n", string.format("<space>%d", idx), function()
            harpoon:list():select(idx)
        end, { desc = string.format("Harpoon item jump %s", idx) })
    end

    harpoon:extend {
        UI_CREATE = function(cx)
            vim.keymap.set("n", "<C-v>", function()
                harpoon.ui:select_menu_item { vsplit = true }
            end, { buffer = cx.bufnr })

            vim.keymap.set("n", "<C-x>", function()
                harpoon.ui:select_menu_item { split = true }
            end, { buffer = cx.bufnr })

            vim.keymap.set("n", "<C-t>", function()
                harpoon.ui:select_menu_item { tabedit = true }
            end, { buffer = cx.bufnr })
        end,
    }
end

return M
