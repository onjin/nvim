local function options_tmux()
    return {
        -- overwrite default configuration
        -- here, e.g. to enable default bindings
        copy_sync = {
            -- enables copy sync and overwrites all register actions to
            -- sync registers *, +, unnamed, and 0 till 9 from tmux in advance
            enable = true,
        },
        navigation = {
            -- enables default keybindings (C-hjkl) for normal mode
            enable_default_keybindings = true,
        },
        resize = {
            -- enables default keybindings (A-hjkl) for normal mode
            enable_default_keybindings = true,
        },
    }
end

local function config_tmux()
    local p = require("tmux")
    p.setup(options_tmux())
end


return {
    {
        "aserowy/tmux.nvim",
        config = config_tmux,
    },
    {
        "preservim/vimux",
    },
}
