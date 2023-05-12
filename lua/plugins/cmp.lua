-- luacheck: globals vim
local function setup_luasnip()
    local luasnip = require("luasnip")

    local options = {
        history = true,
        updateevents = "TextChanged,TextChangedI",
    }

    luasnip.config.set_config(options)
    require("luasnip.loaders.from_vscode").lazy_load()
    require("luasnip.loaders.from_vscode").lazy_load({ paths = vim.g.luasnippets_path or "" })

    vim.api.nvim_create_autocmd("InsertLeave", {
        callback = function()
            if
                require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
                and not require("luasnip").session.jump_active
            then
                require("luasnip").unlink_current()
            end
        end,
    })
end

local function config()
    setup_luasnip()
    local cmp = require("cmp")

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
        Text = " [text]",
        Method = " [method]",
        Function = " [function]",
        Constructor = " [constructor]",
        Field = "ﰠ [field]",
        Variable = " [variable]",
        Class = " [class]",
        Interface = " [interface]",
        Module = " [module]",
        Property = " [property]",
        Unit = " [unit]",
        Value = " [value]",
        Enum = " [enum]",
        Keyword = " [key]",
        Snippet = "﬌ [snippet]",
        Color = " [color]",
        File = " [file]",
        Reference = " [reference]",
        Folder = " [folder]",
        EnumMember = " [enum member]",
        Constant = " [constant]",
        Struct = " [struct]",
        Event = "⌘ [event]",
        Operator = " [operator]",
        TypeParameter = " [type]",
    }

    local cmp_window = require("cmp.utils.window")

    cmp_window.info_ = cmp_window.info
    cmp_window.info = function(self)
        local info = self:info_()
        info.scrollable = false
        return info
    end

    local options = {
        window = {
            completion = {
                border = border("CmpBorder"),
                winhighlight = "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None",
            },
            documentation = {
                border = border("CmpDocBorder"),
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
                    -- cmp_tabnine = "[Tabnine]",
                }
                vim_item.menu = menu_map[entry.source.name] or string.format("[%s]", entry.source.name)

                vim_item.kind = CompletionItemKind[vim_item.kind]
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
            ["<CR>"] = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Replace,
                select = false,
            }),
            ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif require("luasnip").expand_or_jumpable() then
                    vim.fn.feedkeys(
                        vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true),
                        ""
                    )
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
        sources = {
            -- { name = "cmp_tabnine" },
            { name = "nvim_lsp" },
            { name = "luasnip" },
            { name = "nvim_lua" },
            { name = "buffer" },
            { name = "path" },
            { name = "emoji" },
            { name = "crates" },
            { name = "calc" },
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
    {
        "zbirenbaum/copilot-cmp",
        config = function()
            require("copilot_cmp").setup()
        end,
    },
}
