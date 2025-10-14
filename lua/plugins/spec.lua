-- Plugins specification, do not depend on plugin manager.
-- Fields:
--   source   - "owner/repo"
--   name     - optional name (default repo name after /)
--   stage    - "now" | "later" (when to load plugin)
--   depends  - optional dependencies
--   opts     - options for .setup()
--   config   - if there is not `setup()` method or to customize setup
--   pin      - optional ref/branch/tag/commit
--   event    - lazy.nvim specific level (np. "VeryLazy" / "BufReadPre"), ignore in others (FIXME)
--
local setkey = require('utils').setkey

-- Mini plugins - list of mini plugin names to enable - to lazy to write separate add/require/setup
local minis_enabled = {
    "ai", "align", "bracketed", "bufremove", "clue", "completion", "diff", "doc",
    "extra", "files", "fuzzy", "hipatterns", "icons", "indentscope", "keymap",
    "map", "misc", "move", "notify", "operators", "pairs", "pick", "sessions",
    "snippets", "splitjoin", "statusline", "surround", "tabline", "trailspace", "visits",
}

---@type PluginSpecList
local M = {
    {
        source = "catppuccin/nvim",
        name = "catppuccin",
        stage = "now",
        config = function()
            vim.cmd.colorscheme(
                "catppuccin-mocha")
        end,
    },

    -- Nvim-treesitter for syntax colors/indent/etc
    {
        source = "nvim-treesitter/nvim-treesitter",
        name = "nvim-treesitter",
        stage = "later",
        pin = { checkout = "master" }, -- przykładowy pin; engine zinterpretuje jak potrafi
        config = require('plugins.config.treesitter').config,
    },
    -- Class/method context at the top of screen using treesitter
    {
        source = 'nvim-treesitter/nvim-treesitter-context',
        name = 'treesitter-context',
        stage = 'later',
        depends = {
            -- Virtual context endicator at the end class/method/loop
            { source = 'andersevenrud/nvim_context_vt' },
        },
        config = require('plugins.config.treesitter-context').config,
    },

    -- File manager as buffer
    {
        source = "stevearc/oil.nvim",
        name = "oil",
        stage = "later",
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
    { source = "chaoren/vim-wordmotion",        stage = "later" },

    -- Support for loading .editorconfig setting
    { source = "editorconfig/editorconfig-vim", stage = "later" },

    -- TODO/FIXME & other tags highlightning
    { source = 'folke/todo-comments.nvim',      stage = "later", opts = require('plugins.config.todo-comments') },

    -- Show menu with mappings
    {
        source = 'folke/which-key.nvim',
        stage = 'now',
        config = function()
            vim.keymap.set("n", "<leader>?", function() require("which-key").show({ global = false }) end,
                { desc = "Buffer Local Keymaps (which-key)" })
            vim.keymap.set("n", "<leader>/", function() require("which-key").show({ global = true }) end,
                { desc = "Buffer Local Keymaps (which-key)" })
        end
    },

    -- mini-git - has a 'dash' instead of 'dot' so it is not on a 'minis_enabled' list
    { source = 'nvim-mini/mini-git',           name = 'mini.git', stage = 'later' },

    -- code outline side window
    {
        source = 'stevearc/aerial.nvim',
        name = 'aerial',
        stage = 'later',
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
    { source = 'rafamadriz/friendly-snippets', stage = 'later' },

    -- Generate docstrings using :Neogen
    { source = 'danymat/neogen',               stage = 'later' },

    -- Harpoon2 - it is nice to jump between marked files
    {
        source = 'ThePrimeagen/harpoon',
        pin = { checkout = 'harpoon2' },
        depends = {
            { source = 'nvim-lua/plenary.nvim' },
        },
        config = require("plugins.config.harpoon").config
    },
}

for _, mod in ipairs(minis_enabled) do
    ---@type PluginSpec
    table.insert(M, {
        source = "nvim-mini/mini." .. mod,
        name = "mini." .. mod,
        stage = "later", --
        config = (mod == "hipatterns") and function()
                local hipatterns = require("mini.hipatterns")

                hipatterns.setup({
                    highlighters = {
                        hex_color = hipatterns.gen_highlighter.hex_color(),
                    },
                })
            end or (mod == 'icons') and function()
                require('mini.icons').tweak_lsp_kind()
                require('mini.icons').mock_nvim_web_devicons()
            end or (mod == "snippets") and function()
                local gen_loader = require('mini.snippets').gen_loader
                require('mini.snippets').setup({
                    snippets = {
                        -- Load snippets based on current language by reading files from
                        -- "snippets/" subdirectories from 'runtimepath' directories.
                        gen_loader.from_lang(),
                    },
                })
                require('mini.snippets').start_lsp_server() -- add snippets to LSP engine / completion
            end or (mod == "notify") and function()
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
            end or
            nil,
    })
end

return M
