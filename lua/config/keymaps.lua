local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Basic movement keybinds, these make navigating splits easy for me
map("n", "<c-j>", "<c-w><c-j>")
map("n", "<c-k>", "<c-w><c-k>")
map("n", "<c-l>", "<c-w><c-l>")
map("n", "<c-h>", "<c-w><c-h>")

-- Toggle hlsearch if it's on, otherwise just do "enter"

map("n", "<C-/>", function()
  if vim.opt.hlsearch then
    ---@diagnostic disable-next-line: undefined-field
    vim.cmd.nohl()
  end
end)

-- There are builtin keymaps for this now, but I like that it shows
-- the float when I navigate to the error - so I override them.
map("n", "]d", vim.diagnostic.goto_next)
map("n", "[d", vim.diagnostic.goto_prev)
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })

map("n", "<leader>tD", function()
  if vim.diagnostic.is_enabled() then
    vim.diagnostic.enable(false)
  else
    vim.diagnostic.enable(true)
  end
end, { desc = "[T]oggle All [D]iagnostics" })

map("n", "<leader>td", function()
  local current_value = vim.diagnostic.config().virtual_text
  if current_value then
    vim.diagnostic.config { virtual_text = false }
  else
    vim.diagnostic.config { virtual_text = true }
  end
end, { desc = "[T]oggle Virtual [d]iagnostics" })

-- These mappings control the size of splits (height/width)
map("n", "<M-,>", "<c-w>5<")
map("n", "<M-.>", "<c-w>5>")
map("n", "<M-t>", "<C-W>+")
map("n", "<M-s>", "<C-W>-")

map("n", "<M-j>", function()
  if vim.opt.diff:get() then
    vim.cmd [[normal! ]c]]
  else
    vim.cmd [[m .+1<CR>==]]
  end
end)

map("n", "<M-k>", function()
  if vim.opt.diff:get() then
    vim.cmd [[normal! [c]]
  else
    vim.cmd [[m .-2<CR>==]]
  end
end)

map("n", "<leader>tm", function()
  vim.o.scrolloff = 9999 - vim.o.scrolloff
end, { noremap = true, silent = true, desc = "[T]oggle [M]iddle line focus" }) -- toggle centering cursor at middle line

-- Easily hit escape in terminal mode.
map("t", "<esc><esc>", "<c-\\><c-n>")

-- Open a terminal at the bottom of the screen with a fixed height.
map("n", "<leader>st", function()
  vim.cmd.new()
  vim.cmd.wincmd "J"
  vim.api.nvim_win_set_height(0, 12)
  vim.wo.winfixheight = true
  vim.cmd.term()
end)

-- Run tests on current file
map("n", "<localleader>T", "<cmd>PlenaryBustedFile %<CR>")

-- Set up an autocommand for LspAttach
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local lsp_opts = function(desc)
      return { noremap = true, silent = true, buffer = bufnr, desc = "LSP: " .. desc }
    end

    -- use upcoming nvim 0.11 mappings
    -- Normal mode mappings
    map("n", "gO", vim.lsp.buf.document_symbol, lsp_opts "Document Symbols")
    map("n", "grC", vim.lsp.buf.incoming_calls, lsp_opts "Incoming Calls")
    map("n", "grD", vim.lsp.buf.declaration, lsp_opts "Declaration")
    map("n", "gra", vim.lsp.buf.code_action, lsp_opts "Code Action")
    map("n", "grc", vim.lsp.buf.outgoing_calls, lsp_opts "Outgoing Calls")
    map("n", "grd", vim.lsp.buf.definition, lsp_opts "Definition")
    map("n", "gri", vim.lsp.buf.implementation, lsp_opts "Implementation")
    map("n", "grn", vim.lsp.buf.rename, lsp_opts "Rename")
    map("n", "grr", vim.lsp.buf.references, lsp_opts "References")
    map("n", "grt", vim.lsp.buf.type_definition, lsp_opts "Type Definition")
    map("n", "K", vim.lsp.buf.hover, lsp_opts "Hover Documentation")

    -- Visual mode mappings
    map("v", "gra", vim.lsp.buf.code_action, lsp_opts "Code Action") -- Code Action (Visual mode)

    -- Insert mode mappings
    map("i", "<C-s>", vim.lsp.buf.signature_help, lsp_opts "Signature Help") -- Signature Help
  end,
})
