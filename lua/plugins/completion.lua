local function setup_completion()
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
    { name = "codeium" },
  }

  cmp.setup {
    window = {
      completion = {
        winhighlight = "Normal:Pmenu,CursorLine:CmpCursorLine,Search:None",
        col_offset = -3,
        side_padding = 0,
      },
    },
    formatting = {
      expandable_indicator = false,
      fields = { "kind", "abbr", "menu" },
      format = function(entry, vim_item)
        local kind = require("lspkind").cmp_format { mode = "symbol_text", maxwidth = 50 }(entry, vim_item)
        local strings = vim.split(kind.kind, "%s", { trimempty = true })
        kind.kind = " " .. (strings[1] or "") .. " "
        kind.menu = "    (" .. (strings[2] or "") .. ")"
        if kind.kind == " Codeium " then
          kind.kind = " λ "
        end

        return kind
      end,
    },
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
end
return {
  {
    "hrsh7th/nvim-cmp",
    lazy = false,
    priority = 100,
    dependencies = {
      "onsails/lspkind.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      { "L3MON4D3/LuaSnip", build = "make install_jsregexp" },
      "saadparwaiz1/cmp_luasnip",
      "nvim-lua/plenary.nvim",
    },
    config = setup_completion,
  },
}
