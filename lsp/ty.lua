local function resolve_cmd()
    if vim.fn.executable("uvx") == 1 then
        return { "uvx", "ty", "server" }
    end
    return { "ty", "server" }
end

return {
    cmd = resolve_cmd(),
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
    single_file_support = true,
}
