vim.cmd("syntax off")

-- Enable Tree-sitter on buffer enter
-- vim.api.nvim_create_autocmd("BufReadPost", {
--   callback = function()
--     pcall(vim.treesitter.start, 0)
--   end,
-- })
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
