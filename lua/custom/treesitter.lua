-- local treesitter = require "nvim-treesitter"

local M = {}

M.setup = function()
  local group = vim.api.nvim_create_augroup("custom-treesitter", { clear = true })

  require("nvim-treesitter").setup {
    ensure_install = {
      "bash",
      "comment",
      "dockerfile",
      "gitattributes",
      "gitignore",
      "html",
      "javascript",
      "json",
      "latex",
      "lua",
      "make",
      "markdown",
      "markdown_inline",
      "python",
      "regex",
      "sql",
      "todotxt",
      "toml",
      "vim",
      "yaml",
      "comment",
      "gitcommit",
      "go",
      "hcl",
      "htmldjango",
      "http",
      "ini",
      "regex",
      "rst",
      "rust",
      "ssh_config",
      "terraform",
    },
  }
  vim.opt.foldmethod = "expr"
  vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

  local syntax_on = {
    elixir = true,
    php = true,
    python = true,
    lua = true,
  }

  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    callback = function(args)
      local bufnr = args.buf
      local ft = vim.bo[bufnr].filetype
      pcall(vim.treesitter.start)

      if syntax_on[ft] then
        vim.bo[bufnr].syntax = "on"
      end
    end,
  })

  vim.keymap.set("n", "<leader>jc", function()
    require("treesitter-context").go_to_context(vim.v.count1)
  end, { desc = "󰆧  Jump to current_context" })

  vim.keymap.set("n", "<leader>tc", function()
    require("treesitter-context").toggle()
  end, { desc = "[T]oggle TreeSitter [C]ontext" })
end

M.setup()

return M
