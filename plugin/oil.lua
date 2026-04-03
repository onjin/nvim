vim.pack.add {
  "https://github.com/stevearc/oil.nvim",
  "https://github.com/benomahony/oil-git.nvim",
}
local detail = false

require("oil").setup {
  keymaps = {
    ["<C-h>"] = false,
    ["gd"] = {
      desc = "Toggle file detail view",
      callback = function()
        detail = not detail
        if detail then
          require("oil").set_columns { "icon", "permissions", "size", "mtime" }
        else
          require("oil").set_columns { "icon" }
        end
      end,
    },
  },
  columns = { "icon" },
  delete_to_trash = true,
  skip_confirm_for_simple_edits = true,
  view_options = { show_hidden = true },
}
require("oil-git").setup {}

vim.keymap.set("n", "-", ":Oil<CR>", { silent = true })
