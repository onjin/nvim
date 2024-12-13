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
         local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
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

-- Customization for CmpCursorline cause is same as not selected
local mocha = require("catppuccin.palettes").get_palette "mocha"
vim.api.nvim_set_hl(0, "CmpCursorLine", { bg = mocha.base, fg = mocha.pink })
