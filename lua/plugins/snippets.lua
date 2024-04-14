-- luacheck: globals vim
local function config()
    local luasnip = require("luasnip")

    local options = {
        history = true,
        updateevents = "TextChanged,TextChangedI",
    }

    luasnip.config.set_config(options)
    require("luasnip.loaders.from_vscode").lazy_load()
    require("luasnip.loaders.from_vscode").lazy_load({ paths = vim.g.luasnippets_path or "~/.config/nvim/snippets" })
    require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/LuaSnip/" })

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

return {
    {
        "L3MON4D3/LuaSnip",
        config = config,
        lazy = true,
        event = "InsertEnter",
        dependencies = {
            "rafamadriz/friendly-snippets",
        },
    },
}
