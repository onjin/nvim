local lsp_cfg = require("config.lsp")
local python_cfg = require("config.python")
local server_cfg = lsp_cfg.get("python", "basedpyright")
local uv = vim.loop

local function contains(tbl, value)
    for _, item in ipairs(tbl) do
        if item == value then return true end
    end
    return false
end

local function activate_venv(venv_path)
    local command = "source " .. venv_path .. "/bin/activate"
    vim.env.VIRTUAL_ENV = venv_path
    vim.env.PATH = venv_path .. "/bin:" .. vim.env.PATH
    vim.notify("[LSP] Activated venv " .. venv_path)
end

local function site_packages_from_venv(venv)
    if sep == "\\" then
        local path = vim.fs.joinpath(venv, "Lib", "site-packages")
        return uv.fs_stat(path) and path or nil
    end

    local lib_dir = vim.fs.joinpath(venv, "lib")
    local handle = uv.fs_scandir(lib_dir)
    if not handle then return nil end

    while true do
        local name = uv.fs_scandir_next(handle)
        if not name then break end
        if name:match("^python%d%.%d+") then
            local candidate = vim.fs.joinpath(lib_dir, name, "site-packages")
            if uv.fs_stat(candidate) then
                return candidate
            end
        end
    end
    return nil
end


return {
    cmd = { "basedpyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "settings.py", ".git" },
    before_init = function(_, new_config)
        local venv_path = vim.fn.getcwd() .. "/.venv"
        if vim.fn.isdirectory(venv_path) == 1 then
            activate_venv(venv_path)

            local python_path = venv_path .. "/bin/python"
            local site_packages = site_packages_from_venv(venv_path)
            local settings = new_config.settings or {}
            settings.python = settings.python or {}

            if python_path and uv.fs_stat(python_path) then
                settings.python.pythonPath = python_path
            end
            if site_packages then
                settings.python.analysis = settings.python.analysis or {}
                local extra_paths = settings.python.analysis.extraPaths or {}
                if not contains(extra_paths, site_packages) then
                    table.insert(extra_paths, site_packages)
                end
                settings.python.analysis.extraPaths = extra_paths
            end

            new_config.settings = settings
        end
    end,
    on_init = function(client)
        client.offset_encoding = "utf-16"
        python_cfg.apply_diagnostics_policy(client)
        if client.config.settings then
            client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
        end
    end,
    on_attach = function(_) end,
    single_file_support = true,
    settings = server_cfg and vim.deepcopy(server_cfg.settings) or nil,
}
