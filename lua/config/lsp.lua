local M = {}

M.servers = {
    python = {
        preferred_type_server = "basedpyright", -- set to "ty" to use Ty as the primary type provider
        basedpyright = {
            enabled = false,
            settings = {
                basedpyright = {
                    -- Using Ruff's import organizer
                    disableOrganizeImports = true,
                },
                python = {
                    analysis = {
                        autoImportCompletions = true,
                        autoSearchPaths = true,
                        diagnosticMode = "workspace",
                        typeCheckingMode = "standard",
                        diagnosticSeverityOverrides = {
                            reportPrivateImportUsage = "none",
                        },
                    },
                },
            },
        },
        ruff = {
            enabled = true,
            init_options = {
                settings = {
                    organizeImports = true,
                    lint = {
                        extendSelect = {
                            "A",
                            "ARG",
                            "B",
                            "COM",
                            "C4",
                            "FBT",
                            "I",
                            "ICN",
                            "N",
                            "PERF",
                            "PL",
                            "Q",
                            "RET",
                            "RUF",
                            "SIM",
                            "SLF",
                            "TID",
                            "W",
                        },
                        ignore = {
                            "W191",   -- tab-indentation
                            "E111",   -- indentation-with-invalid-multiple
                            "E114",   -- indentation-with-invalid-multiple-comment
                            "E117",   -- over-indented
                            "D206",   -- docstring-tab-indentation
                            "D300",   -- triple-single-quotes
                            "Q000",   -- bad-quotes-inline-string
                            "Q001",   -- bad-quotes-multiline-string
                            "Q002",   -- bad-quotes-docstring
                            "Q003",   -- avoidable-escaped-quote
                            "COM812", -- missing-trailing-comma
                            "COM819", -- prohibited-trailing-comma
                            "ISC002", -- multi-line-implicit-string-concatenation
                        },
                    },
                },
            },
        },
        ty = {
            enabled = true,
            settings = {
                ty = {
                    diagnosticMode = 'workspace',
                }
            }
        },
    },
    lua = {
        lua_ls = {
            enabled = true,
        },
    },
    markdown = {
        marksman = {
            enabled = true,
        },
    },
    nix = {
        nixd = {
            enabled = true,
        },
    },
    sh = {
        bashls = {
            enabled = true,
        },
    },
    toml = {
        taplo = {
            enabled = true,
        },
    },
    yaml = {
        yamlls = {
            enabled = true,
        },
    },
    json = {
        jsonls = {
            enabled = true,
        },
    },
    xml = {
        lemminx = {
            enabled = true,
        },
    },
    java = {
        jdtls = {
            enabled = true,
        },
    },
    rust = {
        rust_analyzer = {
            enabled = true,
            settings = {
                ["rust-analyzer"] = {
                    cargo = { allFeatures = true },
                    check = { command = "clippy" },
                    procMacro = { enable = true },
                },
            },
        },
    },
}

local function normalize_entry(entry)
    if entry == nil then return nil end
    if type(entry) == "boolean" then
        return { enabled = entry }
    end
    return entry
end

function M.get(ft, server)
    local ft_cfg = M.servers[ft]
    if not ft_cfg then return nil end
    return normalize_entry(ft_cfg[server])
end

function M.get_python_type_server()
    local ft_cfg = M.servers.python or {}
    local preferred = ft_cfg.preferred_type_server
    if preferred == "ty" then
        return "ty"
    end
    return "basedpyright"
end

function M.is_enabled(ft, server)
    local entry = M.get(ft, server)
    if entry == nil then return true end
    if entry.enabled == nil then return true end
    return entry.enabled
end

function M.get_settings(ft, server)
    local entry = M.get(ft, server)
    return entry and entry.settings or nil
end

function M.get_init_options(ft, server)
    local entry = M.get(ft, server)
    return entry and entry.init_options or nil
end

return M
