local minis = {
    ["mini.ai"] = { enabled = true },
    ["mini.align"] = { enabled = true },
    ["mini.animate"] = { enabled = true },
    ["mini.base16"] = { enabled = false },
    ["mini.basics"] = { enabled = false },
    ["mini.bracketed"] = { enabled = true },
    ["mini.bufremove"] = { enabled = true },
    ["mini.clue"] = { enabled = true },
    ["mini.colors"] = { enabled = false },
    ["mini.comment"] = { enabled = false },
    ["mini.completion"] = { enabled = true },
    ["mini.cursorword"] = { enabled = true },
    ["mini.deps"] = { enabled = true },
    ["mini.diff"] = { enabled = true },
    ["mini.doc"] = { enabled = true },
    ["mini.extra"] = { enabled = true },
    ["mini.files"] = { enabled = true },
    ["mini.fuzzy"] = { enabled = true },
    ["mini.hipatterns"] = { enabled = true },
    ["mini.hues"] = { enabled = false },
    ["mini.icons"] = { enabled = true },
    ["mini.indentscope"] = { enabled = true },
    ["mini.jump2d"] = { enabled = false },
    ["mini.jump"] = { enabled = false },
    ["mini.keymap"] = { enabled = true },
    ["mini.map"] = { enabled = true },
    ["mini.misc"] = { enabled = true },
    ["mini.move"] = { enabled = true },
    ["mini.notify"] = { enabled = true },
    ["mini.operators"] = { enabled = true },
    ["mini.pairs"] = { enabled = true },
    ["mini.pick"] = { enabled = true },
    ["mini.sessions"] = { enabled = true },
    ["mini.snippets"] = { enabled = true },
    ["mini.splitjoin"] = { enabled = true },
    ["mini.starter"] = { enabled = false },
    ["mini.statusline"] = { enabled = true },
    ["mini.surround"] = { enabled = true },
    ["mini.tabline"] = { enabled = true },
    ["mini.test"] = { enabled = false },
    ["mini.trailspace"] = { enabled = true },
    ["mini.visits"] = { enabled = true },
}
-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
    vim.cmd('echo "Installing `mini.nvim`" | redraw')
    local clone_cmd = { 'git', 'clone', '--filter=blob:none', 'https://github.com/nvim-mini/mini.nvim', mini_path }
    vim.fn.system(clone_cmd)
    vim.cmd('packadd mini.nvim | helptags ALL')
    vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- Set up 'mini.deps' (customize to your liking)
require('mini.deps').setup({ path = { package = path_package } })

-- Use 'mini.deps'. `now()` and `later()` are helpers for a safe two-stage
-- startup and are optional.
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- Safely execute immediately
now(function()
    vim.o.termguicolors = true
end)

now(function()
    -- Use other plugins with `add()`. It ensures plugin is available in current
    -- session (installs if absent)
    add({ source = "catppuccin/nvim", name = "catppuccin" })
    vim.cmd('colorscheme catppuccin-mocha')
end)
later(function()
    for module, config in pairs(minis) do
        if config.enabled then
            add("nvim-mini/" .. module)
            local ok, mod = pcall(require, module)
            if not ok then
                vim.notify("❌ Failed to load module: " .. module .. "\n" .. mod, vim.log.levels.ERROR)
            else
                if type(mod.setup) == "function" then
                    local ok2, err = pcall(mod.setup, config.opts or {})
                    if not ok2 then
                        vim.notify("❌ Error in setup for " .. module .. ": " .. err, vim.log.levels.ERROR)
                    end
                end
            end
        end
    end

    require('mini.icons').tweak_lsp_kind()

    -- mini.hipatterns
    add("nvim-mini/mini.hipatterns")
    local hipatterns = require("mini.hipatterns")
    local extra = require('mini/extra')
    local words = extra.gen_highlighter.words

    hipatterns.setup({
        highlighters = {
            hex_color = hipatterns.gen_highlighter.hex_color(),
            todo = words({ "TODO", "todo" }, "MiniHipatternsTodo"),
            note = words({ "NOTE", "note" }, "MiniHipatternsNote"),
            fixme = words({ "FIXME", "fixme" }, "MiniHipatternsFixme"),
            deprecate = words({ "DEPRECATE", "deprecate" }, "MiniHipatternsDeprecate"),
        },
    })


    -- Censor sensitive information: >lua

    local censor_extmark_opts = function(_, match, _)
        local mask = string.rep('x', vim.fn.strchars(match))
        return {
            virt_text = { { mask, 'Comment' } },
            virt_text_pos = 'overlay',
            priority = 200,
            right_gravity = false,
        }
    end
    require('mini.hipatterns').setup({
        highlighters = {
            censor001 = { pattern = 'PASSWORD=()%S+()', group = '', extmark_opts = censor_extmark_opts },  -- PASSWORD=aaaa
            censor002 = { pattern = "API_KEY=()%S+()", group = '', extmark_opts = censor_extmark_opts },   -- API_KEY="qqrq"
            censor003 = { pattern = 'SECRET_ID=()%S+()', group = '', extmark_opts = censor_extmark_opts }, -- SECRET_ID='some'
        },
    })
    add({
        source = 'nvim-treesitter/nvim-treesitter',
        -- Use 'master' while monitoring updates in 'main'
        checkout = 'master',
        monitor = 'main',
        -- Perform action after every checkout
        hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
    })
    require('nvim-treesitter.configs').setup({
        auto_install = true,
        ensure_installed = { 'lua', 'vimdoc', 'python', 'java', 'bash' },
        highlight = { enable = true },
    })

    add({ source = "stevearc/oil.nvim", name = "oil" })
    require("oil").setup({
        keymaps = {
            ["<C-h>"] = false,
            ["<M-h>"] = "actions.select_split",
        },
        view_options = {
            show_hidden = true,
        },

    })
    vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
end)
