vim.pack.add { "https://github.com/neovim/nvim-lspconfig" }
vim.pack.add { "https://github.com/folke/lazydev.nvim" }

require("lazydev").setup()

vim.lsp.config("jdtls", {
  filetypes = { "java" },
})
vim.lsp.enable "jdtls"

vim.lsp.config("lua_ls", {
  filetypes = { "lua" },
})
vim.lsp.enable "lua_ls"

vim.lsp.config("ty", {
  cmd = { "uvx", "ty" },
  filetypes = { "python" },
  settings = {
    ty = {
      diagnosticMode = "workspace",
    },
  },
})
vim.lsp.enable "ty"

vim.lsp.config("ruff", {
  cmd = { "uvx", "ruff" },
  filetypes = { "python" },
})
vim.lsp.enable "ruff"

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

    vim.keymap.set("n", "glf", function()
      local supports_formatting = vim.iter(vim.lsp.get_clients { bufnr = args.buf }):any(function(buf_client)
        return buf_client:supports_method "textDocument/formatting"
      end)

      if supports_formatting then
        vim.lsp.buf.format { bufnr = args.buf }
        return
      end

      vim.notify("LSP formatting is not supported for this buffer", vim.log.levels.WARN)
    end, { buffer = args.buf, desc = "Format buffer using LSP", silent = true })
  end,
})
