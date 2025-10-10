return {
    cmd = { "basedpyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "settings.py", ".git" },
    on_init = function(client)
        client.offset_encoding = "utf-8"
    end,
    on_attach = function(client)
    end,
    single_file_support = true,
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
        }
    }
}
