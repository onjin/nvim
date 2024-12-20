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
}
