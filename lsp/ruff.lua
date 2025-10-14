--- Refer to the [documentation](https://docs.astral.sh/ruff/editors/) for more details.
local lsp_cfg = require("config.lsp")

local function resolve_cmd()
    if vim.fn.executable("uvx") == 1 then
        return { "uvx", "ruff", "server" }
    end
    return { "ruff", "server" }
end

---@type vim.lsp.Config
local server_cfg = lsp_cfg.get("python", "ruff")

return {
    cmd = resolve_cmd(),
    filetypes = { 'python' },
    root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', '.git' },
    single_file_support = true,
    init_options = server_cfg and vim.deepcopy(server_cfg.init_options) or nil,

    on_init = function(client)
        client.offset_encoding = "utf-8"
        client.server_capabilities.hoverProvider = false
    end,
    settings = server_cfg and vim.deepcopy(server_cfg.settings) or nil,
}
