-- Plugin specification expressed using lazy.nvim schema.
local setkey = require('utils').setkey

---@type LazySpec
local M = {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        config = function()
            vim.cmd.colorscheme(
                "catppuccin-mocha")
        end,
    },

    -- Nvim-treesitter for syntax colors/indent/etc
    {
        "nvim-treesitter/nvim-treesitter",
        name = "nvim-treesitter",
        branch = "master",
        config = require('plugins.config.treesitter').config,
    },
    -- Class/method context at the top of screen using treesitter
    {
        'nvim-treesitter/nvim-treesitter-context',
        name = 'treesitter-context',
        dependencies = {
            -- Virtual context endicator at the end class/method/loop
            'andersevenrud/nvim_context_vt',
        },
        config = require('plugins.config.treesitter-context').config,
    },

    -- File manager as buffer
    {
        "stevearc/oil.nvim",
        name = "oil",
        event = "VeryLazy",
        config = function()
            require("oil").setup({
                keymaps = { ["<C-h>"] = false, ["<M-h>"] = "actions.select_split" },
                view_options = { show_hidden = true },
            })
            vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
        end,
    },

    -- More useful word motions f.e. CameCase or snake_case split into words
    { "chaoren/vim-wordmotion" },

    -- Support for loading .editorconfig setting
    { "editorconfig/editorconfig-vim" },

    -- TODO/FIXME & other tags highlightning
    { 'folke/todo-comments.nvim',     opts = require('plugins.config.todo-comments') },

    -- Show menu with mappings
    {
        'folke/which-key.nvim',
        lazy = false,
        config = function()
            vim.keymap.set("n", "<leader>?", function() require("which-key").show({ global = false }) end,
                { desc = "Buffer Local Keymaps (which-key)" })
            vim.keymap.set("n", "<leader>/", function() require("which-key").show({ global = true }) end,
                { desc = "Buffer Local Keymaps (which-key)" })
        end
    },

    -- code outline side window
    {
        'stevearc/aerial.nvim',
        name = 'aerial',
        config = function()
            require('aerial').setup({
                on_attach = function(bufnr)
                    vim.keymap.set("n", "{", "<cmd>AerialPrev<cr>", { buffer = bufnr })
                    vim.keymap.set("n", "]", "<cmd>AerialNext<cr>", { buffer = bufnr })
                end
            })
            setkey("n", "<leader>oo", "<cmd>AerialToggle!<cr>", "Open code outline (aerial)")
        end
    },

    -- snippets colletion
    { 'rafamadriz/friendly-snippets' },

    -- Completion engine
    {
        "saghen/blink.cmp",
        version = "v0.*",
        event = "InsertEnter",
        config = require('plugins.config.blink'),
    },

    -- Generate docstrings using :Neogen
    { 'danymat/neogen',              opts = {} },

    -- Harpoon2 - it is nice to jump between marked files
    {
        'ThePrimeagen/harpoon',
        branch = 'harpoon2',
        dependencies = {
            'nvim-lua/plenary.nvim',
        },
        config = require("plugins.config.harpoon").config
    },

    -- Markdown Preview in browser
    {
        "iamcco/markdown-preview.nvim",
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
    },

    -- mini.nvim modules
    {
        "nvim-mini/mini.ai",
        name = "mini.ai",
        opts = {},
    },
    {
        "nvim-mini/mini.align",
        name = "mini.align",
        opts = {},
    },
    {
        "nvim-mini/mini.animate",
        name = "mini.animate",
        opts = {},
    },
    {
        "nvim-mini/mini.bracketed",
        name = "mini.bracketed",
        opts = {},
    },
    {
        "nvim-mini/mini.bufremove",
        name = "mini.bufremove",
        opts = {},
    },
    {
        "nvim-mini/mini.clue",
        name = "mini.clue",
        opts = {},
    },
    {
        "nvim-mini/mini.cursorword",
        name = "mini.cursorword",
        opts = {},
    },
    {
        "nvim-mini/mini.diff",
        name = "mini.diff",
        opts = {},
    },
    {
        "nvim-mini/mini.doc",
        name = "mini.doc",
        opts = {},
    },
    {
        "nvim-mini/mini.extra",
        name = "mini.extra",
        opts = {},
    },
    {
        "nvim-mini/mini.files",
        name = "mini.files",
        opts = {},
    },
    {
        "nvim-mini/mini.fuzzy",
        name = "mini.fuzzy",
        opts = {},
    },
    {
        "nvim-mini/mini-git",
        name = "mini.git",
        opts = {},
    },
    {
        "nvim-mini/mini.hipatterns",
        name = "mini.hipatterns",
        config = function()
            local hipatterns = require("mini.hipatterns")

            hipatterns.setup({
                highlighters = {
                    hex_color = hipatterns.gen_highlighter.hex_color(),
                },
            })
        end,
    },
    {
        "nvim-mini/mini.icons",
        name = "mini.icons",
        config = function()
            require('mini.icons').setup()
            require('mini.icons').tweak_lsp_kind()
            require('mini.icons').mock_nvim_web_devicons()
        end,
    },
    {
        "nvim-mini/mini.indentscope",
        name = "mini.indentscope",
        opts = {},
    },
    {
        "nvim-mini/mini.keymap",
        name = "mini.keymap",
        opts = {},
    },
    {
        "nvim-mini/mini.map",
        name = "mini.map",
        opts = {},
    },
    {
        "nvim-mini/mini.misc",
        name = "mini.misc",
        opts = {},
    },
    {
        "nvim-mini/mini.move",
        name = "mini.move",
        opts = {},
    },
    {
        "nvim-mini/mini.notify",
        name = "mini.notify",
        config = function()
            require('mini.notify').setup({
                -- Content management
                content = {
                    -- Function which formats the notification message
                    -- By default prepends message with notification time
                    format = nil,
                    -- Function which orders notification array from most to least important
                    -- By default orders first by level and then by update timestamp
                    sort = nil,
                },

                -- Notifications about LSP progress
                lsp_progress = {
                    -- Whether to enable showing
                    enable = false,
                    -- Notification level
                    level = 'INFO',
                    -- Duration (in ms) of how long last message should be shown
                    duration_last = 1000,
                },
                -- Window options
                window = {
                    -- Floating window config
                    config = {},
                    -- Maximum window width as share (between 0 and 1) of available columns
                    max_width_share = 0.382,
                    -- Value of 'winblend' option
                    winblend = 25,
                },

            })
        end,
    },
    {
        "nvim-mini/mini.operators",
        name = "mini.operators",
        opts = {},
    },
    {
        "nvim-mini/mini.pairs",
        name = "mini.pairs",
        opts = {},
    },
    {
        "nvim-mini/mini.pick",
        name = "mini.pick",
        opts = {},
    },
    {
        "nvim-mini/mini.sessions",
        name = "mini.sessions",
        opts = {},
    },
    {
        "nvim-mini/mini.snippets",
        name = "mini.snippets",
        config = function()
            local gen_loader = require('mini.snippets').gen_loader
            require('mini.snippets').setup({
                snippets = {
                    -- Load snippets based on current language by reading files from
                    -- "snippets/" subdirectories from 'runtimepath' directories.
                    gen_loader.from_lang(),
                },
            })
            require('mini.snippets').start_lsp_server() -- add snippets to LSP engine / completion
        end,
    },
    {
        "nvim-mini/mini.splitjoin",
        name = "mini.splitjoin",
        opts = {},
    },
    {
        "nvim-mini/mini.statusline",
        name = "mini.statusline",
        opts = {},
    },
    {
        "nvim-mini/mini.surround",
        name = "mini.surround",
        opts = {},
    },
    {
        "nvim-mini/mini.tabline",
        name = "mini.tabline",
        opts = {},
    },
    {
        "nvim-mini/mini.trailspace",
        name = "mini.trailspace",
        opts = {},
    },
    {
        "nvim-mini/mini.visits",
        name = "mini.visits",
        opts = {},
    },
    {
        "kevinhwang91/nvim-ufo",
        dependencies = { 'kevinhwang91/promise-async' },
        config = function()
            require('ufo').setup({
                enable_get_fold_virt_text = true,
                provider_selector = function(bufnr, filetype, buftype)
                    return { 'treesitter', 'indent' }
                end,
            })
            vim.o.fillchars = 'eob: ,fold: ,foldopen:,foldsep: ,foldclose:'
            vim.keymap.set('n', 'K', function()
                local winid = require('ufo').peekFoldedLinesUnderCursor()
                if not winid then
                    vim.lsp.buf.hover()
                end
            end)
        end
    },
}

return M
