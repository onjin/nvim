vim.cmd.packadd "cfilter"
vim.cmd.packadd "nvim.undotree"
vim.cmd.packadd "nvim.difftool"

vim.g.mapleader = ","
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.colorcolumn = "120"
vim.opt.textwidth = 120
vim.opt.completeopt = "menu,menuone,fuzzy,noinsert"
vim.opt.swapfile = false
vim.opt.confirm = true
vim.opt.linebreak = true
vim.opt.termguicolors = true
vim.opt.wildoptions:append { "fuzzy" }
vim.opt.path:append { "**" }
vim.opt.smoothscroll = true
vim.opt.grepprg = "rg --vimgrep --no-messages --smart-case"

vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

function _G.statusline_lsp()
  local clients = vim.lsp.get_clients { bufnr = 0 }
  if vim.tbl_isempty(clients) then
    return ""
  end

  local names = {}
  for _, client in ipairs(clients) do
    names[#names + 1] = client.name
  end

  return " [LSP:" .. table.concat(names, ",") .. "]"
end

vim.opt.statusline = "[%n] %<%f %h%w%m%r%{%v:lua.statusline_lsp()%}%=%-14.(%l,%c%V%) %P"

-- disable mouse popup yet keep mouse enabled
vim.cmd [[
  aunmenu PopUp
  autocmd! nvim.popupmenu
]]

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.diagnostic.config {
  virtual_lines = {
    current_line = true,
  },
}

-- Simple windows navigation, same set in tmux
vim.keymap.set("n", "<c-h>", "<c-w><c-h>", { desc = "Switch split left", noremap = true, silent = true })
vim.keymap.set("n", "<c-j>", "<c-w><c-j>", { desc = "Switch split down", noremap = true, silent = true })
vim.keymap.set("n", "<c-k>", "<c-w><c-k>", { desc = "Switch split up", noremap = true, silent = true })
vim.keymap.set("n", "<c-l>", "<c-w><c-l>", { desc = "Switch split right", noremap = true, silent = true })
