if not _G.python_env_set then
    _G.python_env_set = true
    vim.schedule(function()
        local lsp_cfg = require("config.lsp")
        if lsp_cfg.is_enabled("python", "basedpyright")
            and vim.fn.executable("basedpyright-langserver") == 1 then
            vim.lsp.enable("basedpyright")
        end
        local has_uvx = vim.fn.executable("uvx") == 1
        local has_ruff = vim.fn.executable("ruff") == 1
        if lsp_cfg.is_enabled("python", "ruff") and (has_uvx or has_ruff) then
            vim.lsp.enable("ruff")
        end
        local has_ty = vim.fn.executable("ty") == 1
        if lsp_cfg.is_enabled("python", "ty") and (has_uvx or has_ty) then
            vim.lsp.enable("ty")
        end
    end)
end
