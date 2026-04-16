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
  { src = "https://github.com/lewis6991/hover.nvim" },
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

  require("hover").config {
    --- List of modules names to load as providers.
    providers = {
      "hover.providers.diagnostic",
      "hover.providers.lsp",
      "hover.providers.dap",
      "hover.providers.man",
      "hover.providers.dictionary",
      -- Optional, disabled by default:
      -- 'hover.providers.gh',
      -- 'hover.providers.gh_user',
      -- 'hover.providers.jira',
      -- 'hover.providers.fold_preview',
      -- 'hover.providers.highlight',
    },
    mouse_providers = {
      -- "hover.providers.lsp",
    },
  }
  -- Setup keymaps
  vim.keymap.set("n", "K", function()
    require("hover").open()
  end, { desc = "hover.nvim (open)" })
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

-- inline diagnostic
pack.add {
  { src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim" },
}
require("tiny-inline-diagnostic").setup {
  options = {
    multilines = { enabled = true },
    show_source = { enabled = true },
    override_open_float = true,
  },
}
vim.diagnostic.config { virtual_text = false } -- Disable Neovim's default virtual text diagnostics

vim.keymap.set("n", "<leader>de", "<cmd>TinyInlineDiag enable<cr>", { desc = "Enable diagnostics" })
vim.keymap.set("n", "<leader>dd", "<cmd>TinyInlineDiag disable<cr>", { desc = "Disable diagnostics" })
vim.keymap.set("n", "<leader>dt", "<cmd>TinyInlineDiag toggle<cr>", { desc = "Toggle diagnostics" })
vim.keymap.set(
  "n",
  "<leader>dc",
  "<cmd>TinyInlineDiag toggle_cursor_only<cr>",
  { desc = "Toggle cursor-only diagnostics" }
)
vim.keymap.set("n", "<leader>dr", "<cmd>TinyInlineDiag reset<cr>", { desc = "Reset diagnostic options" })
