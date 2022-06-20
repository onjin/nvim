local M = {}

function M.map(mode, lhs, rhs, opts)
    -- example: map("n", "<Leader>c", "cclose<CR>", { silent = true})
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

return M
