if not _G.java_env_set then
    _G.java_env_set = true
   vim.schedule(function()
       local lsp_cfg = require("config.lsp")
        if lsp_cfg.is_enabled("java", "jdtls") then
            vim.lsp.enable("jdtls")
        end
    end)
end
