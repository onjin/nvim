local utils = require("utils")

if not _G.yaml_env_set then
    _G.yaml_env_set = true
    vim.schedule(function()
        local lsp_cfg = require("config.lsp")
        local enabled = lsp_cfg.is_enabled("yaml", "yamlls")
        local has_server = vim.fn.executable("yaml-language-server") == 1

        if enabled and has_server then
            vim.lsp.enable("yamlls")
        elseif enabled then
            utils.log_warn(table.concat({
                "yaml-language-server is not available in PATH.",
                "NixOS: add `pkgs.nodePackages.yaml-language-server` to your devShell packages or",
                "run `nix profile install nixpkgs#nodePackages.yaml-language-server` for a user install.",
            }, "\n"), { title = "YAML LSP" })
        end
    end)
end

