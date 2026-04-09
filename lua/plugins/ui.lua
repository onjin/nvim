local pack = require "plugins.pack"
local has_ui = #vim.api.nvim_list_uis() > 0

if has_ui then
  require("vim._core.ui2").enable {}
end

pack.add {
  { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
  { src = "https://github.com/nvim-mini/mini.icons" },
  { src = "https://github.com/nvim-mini/mini.tabline", name = "mini.tabline" },
  { src = "https://github.com/nvim-mini/mini.statusline", name = "mini.statusline" },
  { src = "https://github.com/nvim-mini/mini-git", name = "mini.git" },
  { src = "https://github.com/nvim-mini/mini.diff", name = "mini.diff" },
  { src = "https://github.com/nvim-mini/mini.indentscope" },
  { src = "https://github.com/brenoprata10/nvim-highlight-colors" },
}

require("catppuccin").setup {
  flavour = "auto",
  background = {
    light = "latte",
    dark = "mocha",
  },
  transparent_background = false,
}
vim.cmd.colorscheme "catppuccin-nvim"

if has_ui then
  require("mini.icons").setup()
  require("mini.icons").tweak_lsp_kind()
  require("mini.icons").mock_nvim_web_devicons()

  require("mini.tabline").setup()
  require("mini.statusline").setup()
  require("mini.indentscope").setup()
end

require("mini.git").setup()
require("mini.diff").setup()

require("nvim-highlight-colors").setup {
  render = "virtual",
  virtual_symbol = "⚫︎",
  virtual_symbol_suffix = "",
}

if has_ui then
  vim.cmd [[
    aunmenu PopUp
    autocmd! nvim.popupmenu
  ]]
end

vim.diagnostic.config {
  virtual_lines = {
    current_line = true,
  },
}
