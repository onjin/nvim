return {
    cmd = { "bash-language-server", "start" },
    filetypes = { "sh" },
    root_markers = { ".git", "shellcheckrc", ".shellcheckrc" },
    single_file_support = true,
    settings = {
        bashIde = {
            globPattern = "*@(.sh|.inc|.bash|.command)",
        },
    },
}
