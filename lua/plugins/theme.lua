local function setup_catppuccin()
  local catppuccin = require "catppuccin"

  local options = {
    compile = {
      enabled = true,
      path = vim.fn.stdpath "cache" .. "/catppuccin",
    },
    integrations = {
      cmp = true,
      gitsigns = true,
      nvimtree = true,
      treesitter = true,
      notify = true,
      mini = {
        enabled = true,
        indentscope_color = "",
      },
    },
  }
  vim.g.catppuccin_flavour = "mocha"

  catppuccin.setup(options)

  local mocha = require("catppuccin.palettes").get_palette "mocha"
  -- mini.tabline
  vim.api.nvim_set_hl(0, "MiniTablineCurrent", { bg = mocha.surface2, fg = mocha.pink })
  vim.api.nvim_set_hl(0, "MiniTablineModifiedCurrent", { bg = mocha.surface2, fg = mocha.red })

  vim.api.nvim_set_hl(0, "MiniTablineVisible", { bg = mocha.base, fg = mocha.text })
  vim.api.nvim_set_hl(0, "MiniTablineModifiedVisible", { bg = mocha.base, fg = mocha.red })

  vim.api.nvim_set_hl(0, "MiniTablineHidden", { bg = mocha.crust, fg = mocha.overlay1 })
  vim.api.nvim_set_hl(0, "MiniTablineModifiedHidden", { bg = mocha.crust, fg = mocha.red })

  -- nvim-cmp
  vim.api.nvim_set_hl(0, "CmpCursorLine", { bg = mocha.base, fg = mocha.pink })
end
return {
  { "catppuccin/nvim", name = "catppuccin", config = setup_catppuccin },
  {
    "jqno/tranquility.nvim",

    config = function()
      -- vim.cmd.colorscheme "tranquility"

      -- Or pick another scheme:
      -- vim.cmd.colorscheme('tranquil-nord')
      -- vim.cmd.colorscheme('tranquil-catppuccin')
      -- vim.cmd.colorscheme('tranquil-intellij')

      -- Or let Neovim pick one at random:
      -- vim.cmd.colorscheme('tranquil-random')
    end,
  },
  {
    "zenbones-theme/zenbones.nvim",
    -- Optionally install Lush. Allows for more configuration or extending the colorscheme
    -- If you don't want to install lush, make sure to set g:zenbones_compat = 1
    -- In Vim, compat mode is turned on as Lush only works in Neovim.
    dependencies = "rktjmp/lush.nvim",
    lazy = false,
    priority = 1000,
    -- you can set set configuration options here
    -- config = function()
    --     vim.g.zenbones_darken_comments = 45
    --     vim.cmd.colorscheme('zenbones')
    -- end
  },
  {
    "jackplus-xyz/binary.nvim",
    dependencies = "catppuccin/nvim",
    config = function()
      local mocha = require("catppuccin.palettes").get_palette "mocha"
      require("binary").setup {
        style = "system", -- Theme style: "system" | "light" | "dark"
        colors = { -- Colors used for the "light" theme; reversed automatically for "dark"
          fg = mocha.base, -- Foreground color
          bg = mocha.text, -- Background color
        },
      }
    end,
  },
}
