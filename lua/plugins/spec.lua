-- Plugin specification expressed using lazy.nvim schema.
local setkey = require('utils').setkey

---@type LazySpec
local M = {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
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
        'saghen/blink.cmp',
        -- optional: provides snippets for the snippet source
        dependencies = {
            'rafamadriz/friendly-snippets',
            "mgalliou/blink-cmp-tmux",
            "bydlw98/blink-cmp-env",
            "disrupted/blink-cmp-conventional-commits",
        },

        -- use a release tag to download pre-built binaries
        version = '1.*',
        -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
        -- build = 'cargo build --release',
        -- If you use nix, you can build from source using latest nightly rust with:
        -- build = 'nix run .#build-plugin',

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        ---

        config = require('plugins.config.blink').config,
    },

    -- Generate docstrings using :Neogen
    { 'danymat/neogen',              opts = {} },

    {
        "OXY2DEV/markview.nvim",
        lazy = false,
        config = function()
            require('markview').setup({

                html = {
                    enable = true,
                },
                preview = {
                    enable = false,         -- use <leader>tp to toggle
                    icon_provider = "mini", -- "internal", "mini" or "devicons"
                }

            })
            vim.api.nvim_set_keymap("n", "<leader>tp", "<CMD>Markview<CR>",
                { desc = "Toggles `markview` previews globally." });
        end
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
        "folke/snacks.nvim",
        lazy = false,
        priority = 1000,
        config = require("plugins.config.snacks"),
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
                open_fold_hl_timeout = 150,
                close_fold_kinds_for_ft = {
                    default = { 'imports', 'comment' },
                    json = { 'array' },
                    c = { 'comment', 'region' },
                    python = { 'import_statement', 'import_from_statement', 'comment' }
                },
                close_fold_current_line_for_ft = {
                    default = true,
                    c = false
                },
            })
            vim.o.fillchars = 'eob: ,fold: ,foldopen:,foldsep: ,foldclose:'
            vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
            vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
            vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds)
            vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith) -- closeAllFolds == closeFoldsWith(0)
            vim.keymap.set('n', 'zk', function()
                local winid = require('ufo').peekFoldedLinesUnderCursor()
            end)
        end
    },
    -- Discord presence
    {
        'vyfor/cord.nvim',
        build = ':Cord update',
        config = require('plugins.config.cord').config,
    },
    -- AI Windsurf plugin
    {
        "Exafunction/windsurf.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            if vim.g.ai_enabled then
                require("codeium").setup({
                    virtual_text = { enabled = false },
                    enable_cmp_source = false,
                })
            end
        end,
    },
    {
        'toppair/reach.nvim',
        config = function()
            require('reach').setup({ notifications = true })
            vim.keymap.set("n", "<leader>rb", function() require('reach').buffers({ show_current = true }) end,
                { desc = "Open Buffers List" })
            vim.keymap.set("n", "<leader>rm", function() require('reach').marks() end, { desc = "Open Buffers List" })
        end
    },
    {
        "chentoast/marks.nvim",
        opts = {
            -- whether to map keybinds or not. default true
            default_mappings = true,
            -- which builtin marks to show. default {}
            builtin_marks = { ".", "<", ">", "^" },
            -- whether movements cycle back to the beginning/end of buffer. default true
            cyclic = true,
            -- whether the shada file is updated after modifying uppercase marks. default false
            force_write_shada = false,
            -- how often (in ms) to redraw signs/recompute mark positions.
            -- higher values will have better performance but may cause visual lag,
            -- while lower values may cause performance penalties. default 150.
            refresh_interval = 250,
            -- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
            -- marks, and bookmarks.
            -- can be either a table with all/none of the keys, or a single number, in which case
            -- the priority applies to all marks.
            -- default 10.
            sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
            -- disables mark tracking for specific filetypes. default {}
            excluded_filetypes = {},
            -- disables mark tracking for specific buftypes. default {}
            excluded_buftypes = {},
            -- marks.nvim allows you to configure up to 10 bookmark groups, each with its own
            -- sign/virttext. Bookmarks can be used to group together positions and quickly move
            -- across multiple buffers. default sign is '!@#$%^&*()' (from 0 to 9), and
            -- default virt_text is "".
            bookmark_0 = {
                sign = "⚑",
                virt_text = "group #0",
                -- explicitly prompt for a virtual line annotation when setting a bookmark from this group.
                -- defaults to false.
                annotate = false,
            },
            mappings = {}
        }
    },
    -- Oli like quickfix list
    {
        'stevearc/quicker.nvim',
        ft = "qf",
        opts = {
            keys = {
                {
                    ">",
                    function()
                        require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
                    end,
                    desc = "Expand quickfix context",
                },
                {
                    "<",
                    function()
                        require("quicker").collapse()
                    end,
                    desc = "Collapse quickfix context",
                },
            },

        },
    },
    -- DAPs
    {
        'mfussenegger/nvim-dap',
        dependencies = {
            {
                'mfussenegger/nvim-dap-python',
                config = function()
                    require("dap-python").setup("uv")
                end
            },
            {
                'theHamsta/nvim-dap-virtual-text',
                config = function()
                    require('nvim-dap-virtual-text').setup()
                end
            },
            { 'igorlfs/nvim-dap-view', opts = {} },
        },
        keys = {
            { "<leader>bv", "<cmd>DapViewToggle<cr>" },
            { "<leader>bb", "<cmd>DapToggleBreakpoint<cr>" },
            { "<leader>bc", "<cmd>DapContinue<cr>" },
            { "<leader>bw", "<cmd>DapViewWatch<cr>" },
        }
    }

}

return M
