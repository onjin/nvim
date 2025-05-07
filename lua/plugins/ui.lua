local function setup_mini()
  require("mini.git").setup()
  require("mini.diff").setup()
  require("mini.notify").setup {
    -- Notifications about LSP progress
    lsp_progress = {
      -- Whether to enable showing
      enable = false,
      -- Duration (in ms) of how long last message should be shown
      duration_last = 1000,
    },
  }
  require("mini.statusline").setup()
end
return {
  -- windows separator
  {
    "nvim-zh/colorful-winsep.nvim",
    config = true,
    event = { "WinLeave" },
  },
  -- statusline
  {
    "echasnovski/mini.statusline",
    version = false,
    dependencies = {
      { "echasnovski/mini-git", version = false },
      { "echasnovski/mini.diff", version = false },
      { "echasnovski/mini.notify", version = false },
    },
    config = setup_mini,
  },
  -- notifications
  {
    "rcarriga/nvim-notify",
    opts = {
      level = 2,

      fps = 10,
      render = "compact",
      stages = "fade",
      timeout = 2000,
      top_down = true,
      background_color = "none",
    },
  },
  -- zen mode
  {
    "folke/zen-mode.nvim",
    lazy = false,
    opts = {
      window = {
        backdrop = 0.95,
        width = 120,
        height = 1,
        options = {},
      },
      plugins = {
        options = {
          enabled = true,
          ruler = false,
          showcmd = false,
          laststatus = 0,
        },
        twilight = { enabled = true },
        gitsigns = { enabled = false },
        tmux = { enabled = false },
        kitty = {
          enabled = true,
          font = "+4",
        },
        alacritty = {
          enabled = false,
          font = "14",
        },
        wezterm = {
          enabled = false,
          font = "+4",
        },
      },
      -- on_open = function(win) end,
      on_close = function() end,
    },
  },
}
