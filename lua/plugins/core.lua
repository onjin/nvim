-- core plugins, like movements, splits, indents, autopair, etc
-- setup at: after/plugins/core.lua
local function setup_core()
  require("mini.ai").setup() -- Extend and create a/i textobjects
  require("mini.align").setup() -- Align text interactively
  require("mini.bracketed").setup() -- Go forward/backward with square brackets
  require("mini.icons").setup() -- Icon provider
  require("mini.icons").tweak_lsp_kind "replace" -- prepend lsp icons
  require("mini.indentscope").setup() -- Visualize and work with indent scope
  require("mini.pairs").setup() -- Minimal and fast autopairs
  require("mini.surround").setup() -- Fast and feature-rich surround actions
  require("mini.tabline").setup() -- Minimal and fast tabline showing listed buffers
  require("lastplace").setup()

  local hipatterns = require "mini.hipatterns"
  hipatterns.setup {
    highlighters = {
      -- Highlight hex color strings (`#rrggbb`) using that color
      hex_color = hipatterns.gen_highlighter.hex_color(),
    },
  }
end
return {
  {
    "echasnovski/mini.ai",
    config = setup_core,
    version = false,
    dependencies = {
      { "echasnovski/mini.align", version = false }, -- Align text interactively
      { "echasnovski/mini.bracketed", version = false }, -- Go forward/backward with square brackets
      { "echasnovski/mini.icons", version = false }, -- Icon provider
      { "echasnovski/mini.indentscope", version = false }, -- Visualize and work with indent scope
      { "echasnovski/mini.pairs", version = false }, -- Minimal and fast autopairs
      { "echasnovski/mini.surround", version = false }, -- Fast and feature-rich surround actions
      { "echasnovski/mini.tabline", version = false }, -- Minimal and fast tabline showing listed buffers
      { "editorconfig/editorconfig-vim" }, -- Support .editorconfig file settings
      { "chaoren/vim-wordmotion" }, -- More useful word motions for Vim
      { "echasnovski/mini.hipatterns", version = false }, -- Highlight patterns in text
    },
  },
  {
    "nullromo/go-up.nvim",
    config = function()
      local goUp = require "go-up"
      goUp.setup {}
      -- Use ctrl+. to center the screen
      vim.keymap.set({ "n", "v" }, "<space>.", function()
        require("go-up").centerScreen()
      end, { desc = "center the screen" })

      -- Use <C-,> to align
      vim.keymap.set({ "n", "v" }, "<space>,", function()
        require("go-up").align()
      end, { desc = "align the screen" })
    end,
  },
}
