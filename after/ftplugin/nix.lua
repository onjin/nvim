if not _G.nix_env_set then
    _G.nix_env_set = true
    vim.schedule(function()
        local lsp_cfg = require("config.lsp")
        if lsp_cfg.is_enabled("nix", "nixd") and vim.fn.executable("nixd") == 1 then
            vim.lsp.enable("nixd")
        end
    end)
end
