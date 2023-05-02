return {
    lintCommand = "ruff --quiet ${INPUT}",
    lintStdin = true,
    lintFormats = { "%f:%l:%c: %m" },
    formatCommand = "ruff --stdin-filename ${INPUT} --fix --exit-zero --quiet -",
    formatStdin = true,
}
