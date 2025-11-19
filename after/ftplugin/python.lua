if not _G.python_env_set then
    _G.python_env_set = true
    vim.schedule(function()
        local python_cfg = require("config.python")
        local state = python_cfg.compute_state()
        python_cfg.set_state(state)
        for _, server in ipairs(python_cfg.servers_to_enable(state)) do
            vim.lsp.enable(server)
        end
    end)
end
