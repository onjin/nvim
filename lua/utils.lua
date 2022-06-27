local M = {}

function M.map(mode, lhs, rhs, opts)
    -- example: map("n", "<Leader>c", "cclose<CR>", { silent = true})
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

function M.colors(scheme)
  -- example: colors('PaperColor')
  vim.cmd(string.format('colorscheme %s', scheme))
  require('notify').notify(string.format('Color scheme changed to %s', scheme))
end

return M
