local M = {}

M.servers = {
    python = {
        basedpyright = {
            enabled = true,
            settings = {
                basedpyright = {
                    -- Using Ruff's import organizer
                    disableOrganizeImports = true,
                },
                python = {
                    analysis = {
                        autoImportCompletions = false,
                        autoSeachPaths = false,
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
                    },
                },
            },
        },
        ty = {
            enabled = false,
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
    java = {
        jdtls = {
            enabled = true,
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
