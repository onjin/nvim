local lsp_cfg = require("config.lsp")
local server_cfg = lsp_cfg.get("yaml", "yamlls")

---@type vim.lsp.Config
return {
    cmd = { "yaml-language-server", "--stdio" },
    filetypes = { "yaml", "yml", "yaml.docker-compose", "yaml.gitlab", "yaml.snakemake" },
    root_markers = { ".git", ".yaml-language-server", ".yamllint" },
    single_file_support = true,
    settings = server_cfg and vim.deepcopy(server_cfg.settings) or {
        yaml = {
            format = { enable = true },
            validate = true,
            keyOrdering = false,
            schemaStore = {
                enable = true,
                url = "https://www.schemastore.org/api/json/catalog.json",
            },
        },
    },
}

