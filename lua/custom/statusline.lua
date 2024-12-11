local M = {}

M.setup_mini = function()
   require("mini.icons").setup()
   require("mini.git").setup()
   require("mini.diff").setup()
   require('mini.notify').setup({
      -- Notifications about LSP progress
      lsp_progress = {
         -- Whether to enable showing
         enable = false,
         -- Duration (in ms) of how long last message should be shown
         duration_last = 1000,
      },
   })
   require("mini.statusline").setup()
end

return M
