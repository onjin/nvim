-- luacheck: globals vim
local icons = require "icons"

local function config()
  local cmp = require "cmp"

  -- require("base46").load_highlight "cmp"

  vim.opt.completeopt = "menuone,noselect"

  local function border(hl_name)
    return {
      { "╭", hl_name },
      { "─", hl_name },
      { "╮", hl_name },
      { "│", hl_name },
      { "╯", hl_name },
      { "─", hl_name },
      { "╰", hl_name },
      { "│", hl_name },
    }
  end

  local CompletionItemKind = {
    Text = icons.kinds.Text .. "[text]",
    Method = icons.kinds.Method .. "method]",
    Function = icons.kinds.Function .. "[function]",
    Constructor = icons.kinds.Constructor .. "[constructor]",
    Field = icons.kinds.Field .. "[field]",
    Variable = icons.kinds.Variable .. "[variable]",
    Class = icons.kinds.Class .. "[class]",
    Interface = icons.kinds.Interface .. "[interface]",
    Module = icons.kinds.Module .. "[module]",
    Property = icons.kinds.Property .. "[property]",
    Unit = icons.kinds.Unit .. "[unit]",
    Value = icons.kinds.Value .. "[value]",
    Enum = icons.kinds.Enum .. "[enum]",
    Keyword = icons.kinds.Keyword .. "[keyword]",
    Snippet = icons.kinds.Snippet .. "[snippet]",
    Color = icons.kinds.Color .. "[color]",
    File = icons.kinds.File .. "[file]",
    Reference = icons.kinds.Reference .. "[reference]",
    Folder = icons.kinds.Folder .. "[folder]",
    EnumMember = icons.kinds.EnumMember .. "[enum member]",
    Constant = icons.kinds.Constant .. "[constant]",
    Struct = icons.kinds.Struct .. "[struct]",
    Event = icons.kinds.Event .. "[event]",
    Operator = icons.kinds.Operator .. "[operator]",
    TypeParameter = icons.kinds.TypeParameter .. "[type]",
    CmpItemKindCopilot = icons.git.copilot .. "[copilot]",
    Codeium = icons.misc.codeium,
  }

  local cmp_window = require "cmp.utils.window"

  cmp_window.info_ = cmp_window.info
  cmp_window.info = function(self)
    local info = self:info_()
    info.scrollable = false
    return info
  end

  local options = {
    window = {
      completion = {
        border = border "CmpBorder",
        winhighlight = "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None",
      },
      documentation = {
        border = border "CmpDocBorder",
      },
    },
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    formatting = {
      format = function(entry, vim_item)
        local menu_map = {
          gh_issues = "[Issues]",
          buffer = "[Buf]",
          nvim_lsp = "[LSP]",
          nvim_lua = "[API]",
          path = "[Path]",
          luasnip = "[Snip]",
          tmux = "[Tmux]",
          look = "[Look]",
          rg = "[RG]",
          copilot = "[copilot]",
          codeium = "[codeium]",
          -- cmp_tabnine = "[Tabnine]",
        }
        local menu = menu_map[entry.source.name] or entry.source_name
        vim_item.menu = menu

        local kind = CompletionItemKind[vim_item.kind] or vim_item.kind
        vim_item.kind = kind
        return vim_item
      end,
    },
    mapping = {
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.close(),
      ["<CR>"] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
      },
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif require("luasnip").expand_or_jumpable() then
          vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
        else
          fallback()
        end
      end, {
        "i",
        "s",
      }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif require("luasnip").jumpable(-1) then
          vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
        else
          fallback()
        end
      end, {
        "i",
        "s",
      }),
    },
    sources = cmp.config.sources({
      { name = "nvim_lua" },
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "copilot" },
      { name = "codeium" },
    }, {
      { name = "path" },
      { name = "buffer", keyword_length = 5 },
    }, {
      { name = "emoji" },
      { name = "crates" },
      { name = "calc" },
    }),
    sorting = {
      -- TODO: Would be cool to add stuff like "See variable names before method names" in rust, or something like that.
      comparators = {
        cmp.config.compare.offset,
        cmp.config.compare.exact,
        cmp.config.compare.score,

        -- copied from cmp-under, but I don't think I need the plugin for this.
        -- I might add some more of my own.
        function(entry1, entry2)
          local _, entry1_under = entry1.completion_item.label:find "^_+"
          local _, entry2_under = entry2.completion_item.label:find "^_+"
          entry1_under = entry1_under or 0
          entry2_under = entry2_under or 0
          if entry1_under > entry2_under then
            return false
          elseif entry1_under < entry2_under then
            return true
          end
        end,

        cmp.config.compare.kind,
        cmp.config.compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order,
      },
    },
  }

  cmp.setup(options)
end
return {
  {
    "hrsh7th/nvim-cmp",
    lazy = true,
    event = "InsertEnter",
    config = config,
    dependencies = {
      "rafamadriz/friendly-snippets",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-emoji",
      "hrsh7th/cmp-calc",
      "davidsierradz/cmp-conventionalcommits",
    },
  },
}
