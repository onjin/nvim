vim.pack.add { "https://github.com/neovim/nvim-lspconfig" }
vim.pack.add { "https://github.com/folke/lazydev.nvim" }

require("lazydev").setup()

---@type table<string, vim.lsp.Config|true>
local servers = {
  jdtls = {
    filetypes = { "java" },
  },
  lua_ls = {
    filetypes = { "lua" },
  },
  ty = {
    cmd = { "uvx", "ty" },
    filetypes = { "python" },
    settings = {
      ty = {
        diagnosticMode = "workspace",
      },
    },
  },
  ruff = {
    cmd = { "uvx", "ruff" },
    filetypes = { "python" },
  },
  bashls = true,
}

for name, spec in pairs(servers) do
  vim.lsp.config(name, spec == true and {} or spec)
  vim.lsp.enable(name)
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    vim.o.signcolumn = "yes:1"
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if client:supports_method "textDocument/completion" then
      vim.o.complete = "o,.,w,b,u"
      vim.o.completeopt = "menu,menuone,popup,noinsert"
      vim.lsp.completion.enable(true, client.id, args.buf)
    end
    if client:supports_method "textDocument/inlayHint" then
      vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    end
    vim.keymap.set("n", "grd", vim.lsp.buf.definition, { desc = "vim.lsp.buf.definition" })
  end,
})
