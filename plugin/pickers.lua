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
