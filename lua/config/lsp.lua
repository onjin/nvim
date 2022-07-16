local map = function(mode, lhs, rhs)
  local opts = {remap = false, buffer = bufnr}
  vim.keymap.set(mode, lhs, rhs, opts)
end

local lsp = require('lsp-zero')

lsp.preset('recommended')

local cmp_sources = require('lsp-zero.nvim-cmp-setup').sources()

lsp.setup_nvim_cmp({
    sources = {
        {name = 'path'},
        {name = 'nvim_lsp', keyword_length = 2},
        {name = 'buffer', keyword_length = 3},
        {name = 'luasnip', keyword_length = 2},
        {name = 'calc'},
        -- {name = 'copilot'},
        {name = 'emoji'},
        -- {name = 'tmux', option = {all_panes = true}},
    },
})

-- pyrigh config, f.e. code format using :Black
lsp.configure('pyright', {
  on_attach = function(client, bufnr)
    -- formatting
    map('n', '<leader>cf', '<cmd>:Black<cr>')
    map('v', '<leader>cf', '<cmd>vim.notify("code range format not supported with Black")<cr>')
    map('n', '<leader>ci', '<cmd>PyrightOrganizeImports<cr>')
  end
})


lsp.setup()

require'lspconfig'.sumneko_lua.setup {
  settings = {
    Lua = {
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
    },
  },
}


lsp.on_attach(function(client, bufnr)
  -- vim.notify("Client " .. client.name .. " attached to buffer ".. bufnr, nil, { title = 'LSP'})

  -- LSP actions
  map('n', 'gd', '<cmd>lua require("telescope.builtin").lsp_definitions()<cr>')
  map('n', '<leader>ld', '<cmd>lua require("telescope.builtin").lsp_definitions()<cr>')

  map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')
  map('n', '<leader>lD', '<cmd>lua vim.lsp.buf.declaration()<cr>')

  map('n', 'gi', '<cmd>lua require("telescope.builtin").lsp_implementations()<cr>')
  map('n', '<leader>li', '<cmd>lua require("telescope.builtin").lsp_implementations()<cr>')

  map('n', 'gt', '<cmd>lua require("telescope.builtin").lsp_type_definitions()<cr>')
  map('n', '<leader>lt', '<cmd>lua require("telescope.builtin").lsp_type_definitions()<cr>')

  map('n', 'gr', '<cmd>lua require("telescope.builtin").lsp_references()<cr>')
  map('n', '<leader>lr', '<cmd>lua require("telescope.builtin").lsp_references()<cr>')

  map('n', 'gs', '<cmd>lua require("telescope.builtin").lsp_document_symbols()<cr>')
  map('n', '<leader>ls', '<cmd>lua require("telescope.builtin").lsp_document_symbols()<cr>')

  map('n', 'gn', '<cmd>lua require("cosmic-ui").rename()<cr>')
  map('n', '<leader>ln', '<cmd>lua require("cosmic-ui").rename()<cr>')

  -- code actions
  map('n', '<leader>ca', '<cmd>lua require("cosmic-ui").code_actions()<cr>')
  map('v', '<leader>ca', '<cmd>lua require("cosmic-ui").range_code_actions()<cr>')

  -- formatting
  map('n', '<leader>cf', '<cmd>lua vim.lsp.buf.format({ async = true })<cr>')
  map('v', '<leader>cf', '<cmd>lua vim.lsp.buf.range_formatting()<cr>')

  -- lsp workspace
  map('n', '<leader>wl', '<cmd>lua vim.lsp.buf.list_workspace_folders()<cr>')
  map('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>')
  map('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>')

  -- Diagnostics
  map('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')
  map('n', '<leader>ll', '<cmd>lua vim.diagnostic.open_float()<cr>')

  map('n', 'ge', '<cmd>lua vim.diagnostic.open_float(nil, { scope = "line", })<cr>')
  map('n', '<leader>le', '<cmd>lua vim.diagnostic.open_float(nil, { scope = "line", })<cr>')

  map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
  map('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')
  map("n", "<Leader>dn", ":lua vim.diagnostic.goto_next()<cr>")
  map("n", "<Leader>dp", ":lua vim.diagnostic.goto_prev()<cr>")
  map("n", "<Leader>dd", ":lua vim.diagnostic.setloclist()<cr>")
  map("n", "<Leader>ca", ":lua vim.lsp.buf.code_action()<cr>")
  if client == 'pyright' then
    map('n', '<leader>cf', '<cmd>:Black<cr>')
    map('v', '<leader>cf', '<cmd>vim.notify("code range format not supported with Black")<cr>')
    map('n', '<leader>ci', '<cmd>PyrightOrganizeImports<cr>')
  end
end)
map("n", "<Leader>dt", ":TroubleToggle<cr>")
