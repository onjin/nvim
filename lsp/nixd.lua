local hostname = vim.loop.os_gethostname() -- HOSTNAME is not exported by bash, only set for session
local user = vim.env.USER

-- Optional parts
local nixos_opts = nil
local home_manager_opts = nil

if hostname ~= nil then
    nixos_opts = {
        nixos = {
            expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.' .. hostname .. '.options',
        },
    }
else
    vim.notify('[nixd] missing HOSTNAME')
end

if user ~= nil then
    home_manager_opts = {
        home_manager = {
            expr = '(builtins.getFlake ("git+file://" + toString ./.)).homeConfigurations."' .. user .. '".options',
        },
    }
else
    vim.notify('[nixd] missing USER')
end

local combined_options = vim.tbl_deep_extend("force", nixos_opts or {}, home_manager_opts or {})


return {
    cmd = { "nixd" },
    filetypes = { "nix" },
    settings = {
        nixd = {
            nixpkgs = {
                expr = "import <nixpkgs> { }",
            },
            formatting = {
                command = { "nixfmt" },
            },
            options = combined_options,
        },

    }
}
