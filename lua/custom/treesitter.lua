-- local treesitter = require "nvim-treesitter"

local M = {}

M.setup = function()
  local group = vim.api.nvim_create_augroup("custom-treesitter", { clear = true })

  require("nvim-treesitter.configs").setup {
    ensure_installed = vim.g.treesitter_ensure_installed,
    -- Autoinstall languages that are not installed
    auto_install = true,
    highlight = {
      enable = true,
      -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
      --  If you are experiencing weird indenting issues, add the language to
      --  the list of additional_vim_regex_highlighting and disabled languages for indent.
      additional_vim_regex_highlighting = { "ruby" },
    },
    indent = { enable = true, disable = { "ruby" } },
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
  vim.keymap.set("n", "<leader>tC", function()
    require("nvim_context_vt").toggle_context()
  end, { desc = "[T]oggle Virtual Text [C]ontext" })
end

M.setup()

return M
