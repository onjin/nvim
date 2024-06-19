require "custom.snippets"
vim.opt.completeopt = { "menu", "menuone", "noselect" }

vim.opt.shortmess:append "c"

local lspkind = require "lspkind"
lspkind.init {}

local cmp = require "cmp"
local sources = {
  { name = "nvim_lsp" },
  { name = "cody" },
  { name = "path" },
  { name = "buffer" },
  { name = "luasnip" },
}

if vim.g.ai_enabled then
  require("codeium").setup {}
  table.insert(sources, { name = "codeium" })
end

cmp.setup {
  sources = sources,
  mapping = {
    ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
    ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
    ["<C-y>"] = cmp.mapping(
      cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      },
      { "i", "c" }
    ),
  },

  -- Enable luasnip to handle snippet expansion for nvim-cmp
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
}

-- Setup up vim-dadbod
cmp.setup.filetype({ "sql" }, {
  sources = {
    { name = "vim-dadbod-completion" },
    { name = "buffer" },
  },
})
