if not _G.python_env_set then
    _G.python_env_set = true
    vim.schedule(function()
        local python_cfg = require("config.python")
        python_cfg.apply_state()
    end)
end
