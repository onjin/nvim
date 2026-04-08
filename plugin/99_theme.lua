-- Experimental ui2
require("vim._core.ui2").enable {}

-- color scheme
vim.pack.add { { src = "https://github.com/catppuccin/nvim", name = "catppuccin", confirm = false } }

require("catppuccin").setup {
  flavour = "auto", -- latte, frappe, macchiato, mocha
  background = { -- :h background
    light = "latte",
    dark = "mocha",
  },
  transparent_background = false, -- disables setting the background color
}
vim.cmd.colorscheme "catppuccin-nvim"

-- Icons pack
vim.pack.add { { src = "https://github.com/nvim-mini/mini.icons", confirm = false } }
require("mini.icons").setup()
require("mini.icons").tweak_lsp_kind()
require("mini.icons").mock_nvim_web_devicons()

-- Tab line (top)
vim.pack.add {
  { src = "https://github.com/nvim-mini/mini.tabline", name = "mini.tabline", confirm = false },
}
require("mini.tabline").setup()

-- Status line (bottom)
vim.pack.add {
  { src = "https://github.com/nvim-mini/mini.statusline", name = "mini.statusline", confirm = false },
  -- dependencies
  { src = "https://github.com/nvim-mini/mini-git", name = "mini.git", confirm = false },
  { src = "https://github.com/nvim-mini/mini.diff", name = "mini.diff", confirm = false },
}
require("mini.git").setup()
require("mini.diff").setup()
require("mini.statusline").setup()

-- Indent indicator
vim.pack.add { { src = "https://github.com/nvim-mini/mini.indentscope", confirm = false } }
require("mini.indentscope").setup()

-- Highlight #FFEEFF patterns
vim.pack.add { { src = "https://github.com/brenoprata10/nvim-highlight-colors", confirm = false } }

require("nvim-highlight-colors").setup {
  render = "virtual",
  virtual_symbol = "⚫︎",
  virtual_symbol_suffix = "",
}

-- disable mouse popup yet keep mouse enabled
vim.cmd [[
  aunmenu PopUp
  autocmd! nvim.popupmenu
]]

-- Highlight copied text
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.diagnostic.config {
  virtual_lines = {
    current_line = true,
  },
}
