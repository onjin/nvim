vim.pack.add { "https://github.com/stevearc/conform.nvim" }

require("conform").setup {
  default_format_opts = {
    -- Allow formatting from LSP server if no dedicated formatter is available
    lsp_format = "fallback",
  },
  -- Map of filetype to formatters
  formatters_by_ft = {
    javascript = { "prettier" },
    json = { "prettier" },
    lua = { "stylua" },
    python = { "black" },
    r = { "air" },
  },
}

vim.keymap.set("n", "glf", "<Cmd>lua require('conform').format()<CR>", { silent = true })
