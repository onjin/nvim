local utils = require("utils")

if not _G.rust_env_set then
    _G.rust_env_set = true
    vim.schedule(function()
        local lsp_cfg = require("config.lsp")
        local enabled = lsp_cfg.is_enabled("rust", "rust_analyzer")
        local has_ra = vim.fn.executable("rust-analyzer") == 1

        if enabled and has_ra then
            vim.lsp.enable("rust_analyzer")
        elseif enabled then
            utils.log_warn(table.concat({
                "rust-analyzer is not available in PATH.",
                "NixOS: add `pkgs.rust-analyzer` to your devShell packages or run `nix profile install nixpkgs#rust-analyzer` for a user install.",
            }, "\n"), { title = "rust-analyzer" })
        end
    end)
end
