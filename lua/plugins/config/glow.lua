local M = {}

function M.config()
    require("glow").setup({
        border = "rounded",
        style = "dark",
        pager = false,
        width_ratio = 0.9,
        height_ratio = 0.9,
    })
end

return M
