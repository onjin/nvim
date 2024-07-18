local set = vim.keymap.set

-- Basic movement keybinds, these make navigating splits easy for me
set("n", "<c-j>", "<c-w><c-j>")
set("n", "<c-k>", "<c-w><c-k>")
set("n", "<c-l>", "<c-w><c-l>")
set("n", "<c-h>", "<c-w><c-h>")

set("n", "<leader>x", "<cmd>.lua<CR>", { desc = "Execute the current line" })
set("n", "<leader><leader>x", "<cmd>source %<CR>", { desc = "Execute the current file" })
-- Toggle hlsearch if it's on, otherwise just do "enter"

set("n", "<C-/>", function()
  if vim.opt.hlsearch then
    ---@diagnostic disable-next-line: undefined-field
    vim.cmd.nohl()
  end
end)

-- There are builtin keymaps for this now, but I like that it shows
-- the float when I navigate to the error - so I override them.
set("n", "]d", vim.diagnostic.goto_next)
set("n", "[d", vim.diagnostic.goto_prev)
set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })

set("n", "<leader>tD", function()
  if vim.diagnostic.is_enabled() then
    vim.diagnostic.enable(false)
  else
    vim.diagnostic.enable(true)
  end
end, { desc = "[T]oggle All [D]iagnostics" })

set("n", "<leader>td", function()
  local current_value = vim.diagnostic.config().virtual_text
  if current_value then
    vim.diagnostic.config { virtual_text = false }
  else
    vim.diagnostic.config { virtual_text = true }
  end
end, { desc = "[T]oggle Virtual [d]iagnostics" })

-- These mappings control the size of splits (height/width)
set("n", "<M-,>", "<c-w>5<")
set("n", "<M-.>", "<c-w>5>")
set("n", "<M-t>", "<C-W>+")
set("n", "<M-s>", "<C-W>-")

set("n", "<M-j>", function()
  if vim.opt.diff:get() then
    vim.cmd [[normal! ]c]]
  else
    vim.cmd [[m .+1<CR>==]]
  end
end)

set("n", "<M-k>", function()
  if vim.opt.diff:get() then
    vim.cmd [[normal! [c]]
  else
    vim.cmd [[m .-2<CR>==]]
  end
end)

set("n", "<leader>tm", function()
  vim.o.scrolloff = 9999 - vim.o.scrolloff
end, { noremap = true, silent = true, desc = "[T]oggle [M]iddle line focus" }) -- toggle centering cursor at middle line

-- obsidian settings
set("n", "<leader>of", ':Telescope find_files search_dirs={"/home/onjin/notes"}<cr>')
set("n", "<leader>og", ':Telescope live_grep search_dirs={"/home/onjin/notes"}<cr>')
