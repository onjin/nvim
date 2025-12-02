local utils = require("utils")

if not _G.toml_env_set then
    _G.toml_env_set = true
    vim.schedule(function()
        local lsp_cfg = require("config.lsp")
        local enabled = lsp_cfg.is_enabled("toml", "taplo")
        local has_server = vim.fn.executable("taplo") == 1

        if enabled and has_server then
            vim.lsp.enable("taplo")
        elseif enabled then
            utils.log_warn(table.concat({
                "taplo is not available in PATH.",
                "NixOS: add `pkgs.taplo` (or `pkgs.taplo-lsp`) to your devShell packages or",
                "run `nix profile install nixpkgs#taplo` for a user install.",
            }, "\n"), { title = "TOML LSP" })
        end
    end)
end

