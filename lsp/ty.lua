local lsp_cfg = require("config.lsp")
local python_cfg = require("config.python")

local function resolve_cmd()
    if vim.fn.executable("uvx") == 1 then
        return { "uvx", "ty", "server" }
    end
    return { "ty", "server" }
end

local server_cfg = lsp_cfg.get("python", "ty")

return {
    cmd = resolve_cmd(),
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
    single_file_support = true,
    init_options = server_cfg and vim.deepcopy(server_cfg.init_options) or nil,
    settings = server_cfg and vim.deepcopy(server_cfg.settings) or nil,
    on_init = python_cfg.apply_diagnostics_policy,
}
