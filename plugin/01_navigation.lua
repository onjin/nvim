-- Simple windows navigation, same set in tmux
vim.keymap.set("n", "<c-h>", "<c-w><c-h>", { desc = "Switch split left", noremap = true, silent = true })
vim.keymap.set("n", "<c-j>", "<c-w><c-j>", { desc = "Switch split down", noremap = true, silent = true })
vim.keymap.set("n", "<c-k>", "<c-w><c-k>", { desc = "Switch split up", noremap = true, silent = true })
vim.keymap.set("n", "<c-l>", "<c-w><c-l>", { desc = "Switch split right", noremap = true, silent = true })

-- File picking
vim.pack.add { "https://github.com/folke/snacks.nvim" }

local ok, snacks = pcall(require, "snacks")
if not ok then
  return
end

snacks.setup {
  picker = {
    enabled = true,
    ui_select = true,
    layout = {
      cycle = true,
    },
  },
}

local picker = Snacks.picker

-- Files search <leaders>s...
vim.keymap.set("n", "<leader>sf", picker.files, { desc = "Search files" })
vim.keymap.set("n", "<leader>sb", picker.buffers, { desc = "Search buffers" })
vim.keymap.set("n", "<leader>sg", picker.git_grep, { desc = "Search live git grep" })
vim.keymap.set("n", "<leader>sG", picker.grep, { desc = "Search live ripgrep" })
vim.keymap.set("n", "<leader>s*", picker.grep_word, { desc = "Grep string under cursor" })
vim.keymap.set("n", "<leader>sr", picker.resume, { desc = "Resume last search" })
vim.keymap.set("n", "<leader>sn", picker.notifications, { desc = "Search notifications" })

-- Find some elements <leader>f...
vim.keymap.set("n", "<Leader>fk", picker.keymaps, { desc = "Find keymaps" })
vim.keymap.set("n", "<Leader>fc", picker.commands, { desc = "Find commands" })
vim.keymap.set("n", "<leader>fs", picker.spelling, { desc = "Find spelling" })
-- Folders as buffer
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
