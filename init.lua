vim.g.mapleader = ","
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.colorcolumn = "120"
vim.opt.textwidth = 120
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

-- Autocomplete
vim.opt.completeopt = "menuone,fuzzy,popup,noinsert,noselect"
-- o - omnifunc
-- . - current buffer
-- w - other windows buffers
-- b - loaded buffers from buffer list
-- u - unloaded buffers from buffer list
vim.opt.complete = "o,.,w,b,u"
vim.opt.autocomplete = false

-- the PackChanged must be registerd before first vim.pack.add
-- at least it occured from my experimens ...
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name = ev.data.spec.name
    local kind = ev.data.kind
    vim.notify("[PackChanged] name=" .. name .. " kind=" .. kind)
    if name == "nvim-treesitter" and kind == "update" then
      vim.notify "[nvim-treesitter] TSUpdate"
      vim.cmd "TSUpdate"
    end
    if name == "tree-sitter-d2" and (kind == "install" or kind == "update") then
      vim.notify "[tree-sitter-d2] make nvim-install"
      vim.system({ "make", "nvim-install" }, { cwd = ev.data.path }):wait()
    end
    if name == "cord.nvim" and kind == "update" then
      if not ev.data.active then
        vim.cmd.packadd "cord.nvim"
      end
      vim.cmd "Cord update"
    end
  end,
})
vim.pack.add {
  "https://github.com/nvim-lua/plenary.nvim", -- required by many plugins
}
