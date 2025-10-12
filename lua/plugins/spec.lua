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
    { source = "chaoren/vim-wordmotion",        stage = "now" },

    -- Support for loading .editorconfig setting
    { source = "editorconfig/editorconfig-vim", stage = "now" },

    -- TODO/FIXME & other tags highlightning
    { source = 'folke/todo-comments.nvim',      stage = "now", opts = require('plugins.config.todo-comments') },

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
    }
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
        end or nil,
    })
end

return M
