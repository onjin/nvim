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
            vim.cmd.colorscheme("catppuccin-mocha")
        end,
    },

    -- Nvim-treesitter for syntax colors/indent/etc
    {
        source = "nvim-treesitter/nvim-treesitter",
        name = "nvim-treesitter",
        stage = "later",
        pin = { checkout = "master" }, -- przykładowy pin; engine zinterpretuje jak potrafi
        config = function()
            require("nvim-treesitter.configs").setup({
                auto_install = true,
                ensure_installed = { "lua", "vimdoc", "python", "java", "bash" },
                highlight = { enable = true },
            })
        end,
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

    -- Mini for all mini plugins (do I need it here? or at engine level?)
    {
        source = "nvim-mini/mini.nvim",
        name = "mini.nvim",
        stage = "now",
    },
}



for _, mod in ipairs(minis_enabled) do
    ---@type PluginSpec
    table.insert(M, {
        source = "nvim-mini/mini." .. mod,
        name = "mini." .. mod,
        stage = "later", --
        opts = (mod == "hipatterns") and {
            highlighters = {
                hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
            },
        } or nil,
    })
end

return M
