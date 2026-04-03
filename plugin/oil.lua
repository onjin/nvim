vim.pack.add({
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/benomahony/oil-git.nvim",
})

require("oil").setup({
	keymaps = { ["<C-h>"] = false },
	columns = { "size", "mtime" },
	delete_to_trash = true,
	skip_confirm_for_simple_edits = true,
})
require("oil-git").setup({})

vim.keymap.set("n", "-", ":Oil<CR>", { silent = true })
