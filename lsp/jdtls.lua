local uv = vim.uv or vim.loop
local fs = vim.fs

local function normalize_file(path)
    if not path or path == "" then
        return nil
    end

    if type(path) == "string" then
        path = path:gsub("%s+$", "")
    end

    local stat = uv.fs_stat(path)
    if stat and stat.type == "file" then
        if fs and fs.normalize then
            return fs.normalize(path)
        end
        return path
    end
end

local function first_existing(candidates)
    for _, candidate in ipairs(candidates) do
        local jar = normalize_file(candidate)
        if jar then
            return jar
        end
    end
end

local function read_file(path)
    if not path or path == "" then
        return nil
    end
    local ok, fd = pcall(uv.fs_open, path, "r", 438) -- 0666
    if not ok or not fd then
        return nil
    end
    local ok_stat, stat = pcall(uv.fs_fstat, fd)
    if not ok_stat or not stat or not stat.size then
        pcall(uv.fs_close, fd)
        return nil
    end
    local ok_data, data = pcall(uv.fs_read, fd, stat.size, 0)
    pcall(uv.fs_close, fd)
    if not ok_data then
        return nil
    end
    return data
end

local function sanitize_workspace_name(path)
    if not path or path == "" then
        return "default"
    end
    local normalized = fs.normalize(path)
    return (normalized:gsub("[/\\:]", "_"):gsub("_+", "_"))
end

local function find_spotless_profile_name(formatter_xml)
    local content = read_file(formatter_xml)
    if not content then
        return nil
    end
    return content:match('<profile%s+name="([^"]+)"')
end

local function java_settings_for_root(root_dir)
    local java = vim.empty_dict()
    if not root_dir or root_dir == "" then
        return { java = java }
    end

    local formatter_xml = normalize_file(fs.joinpath(root_dir, "eclipse.formatter.xml"))
    if not formatter_xml then
        return { java = java }
    end

    local formatter_settings = {
        url = vim.uri_from_fname(formatter_xml),
    }
    local profile_name = find_spotless_profile_name(formatter_xml)
    if profile_name and profile_name ~= "" then
        formatter_settings.profile = profile_name
    end

    java.format = { settings = formatter_settings }
    return { java = java }
end

local function get_java_executable()
    local java_home = vim.env.JAVA_HOME
    if java_home and java_home ~= "" then
        local java_bin = fs.joinpath(java_home, "bin", "java")
        if vim.fn.executable(java_bin) == 1 then
            return java_bin
        end
    end
    return nil
end

local function workspace_dir_for_root(root_dir)
    local base = vim.fn.stdpath("cache")
    return fs.joinpath(base, "jdtls", sanitize_workspace_name(root_dir or uv.cwd()))
end

local function find_lombok()
    -- I installed this by NixOS home-manager, along with sessionVariable
    local jar = first_existing({ vim.env.JDTLS_LOMBOK, vim.env.LOMBOK_JAR })
    if jar then
        return jar
    end

    local jdtls_exec = vim.fn.exepath("jdtls")
    if jdtls_exec ~= "" then
        local bin_dir = fs.dirname(jdtls_exec)
        local profile_dir = bin_dir and fs.dirname(bin_dir) or nil
        local share_dir = profile_dir and fs.joinpath(profile_dir, "share") or nil

        jar = first_existing({
            share_dir and fs.joinpath(share_dir, "java", "lombok.jar"),
            share_dir and fs.joinpath(share_dir, "java", "jdtls", "lombok.jar"),
            bin_dir and fs.joinpath(bin_dir, "..", "share", "java", "lombok.jar"),
            bin_dir and fs.joinpath(bin_dir, "..", "share", "java", "jdtls", "lombok.jar"),
        })
        if jar then
            return jar
        end

        if share_dir then
            local found = fs.find("lombok.jar", { fs.normalize(share_dir) }, { limit = 1 })
            if found[1] then
                jar = normalize_file(found[1])
                if jar then return jar end
            end
        end
    end

    local stdpath = vim.fn.stdpath
    if stdpath then
        local std_candidates = {}
        for _, scope in ipairs({ "data", "state" }) do
            local dir = stdpath(scope)
            if dir and dir ~= "" then
                table.insert(std_candidates, fs.joinpath(dir, "mason", "packages", "jdtls", "lombok.jar"))
                table.insert(std_candidates, fs.joinpath(dir, "java", "jdtls", "lombok.jar"))
                table.insert(std_candidates, fs.joinpath(dir, "java", "lombok.jar"))
            end
        end
        jar = first_existing(std_candidates)
        if jar then
            return jar
        end
    end

    return nil
end

local missing_warned = false
local function warn_missing_lombok()
    if missing_warned then
        return
    end
    missing_warned = true
    vim.schedule(function()
        vim.notify(
            "[jdtls] Lombok jar not found. Set $JDTLS_LOMBOK or $LOMBOK_JAR to the jar path to enable Lombok support.",
            vim.log.levels.WARN
        )
    end)
end

local lombok_jar = find_lombok()
local function build_cmd(root_dir)
    local cmd = { "jdtls" }
    local java_executable = get_java_executable()
    if java_executable then
        table.insert(cmd, "--java-executable")
        table.insert(cmd, java_executable)
    end
    if lombok_jar then
        table.insert(cmd, "--jvm-arg=-javaagent:" .. lombok_jar)
    else
        warn_missing_lombok()
    end
    table.insert(cmd, "-data")
    table.insert(cmd, workspace_dir_for_root(root_dir))
    return cmd
end

return {
    root_markers = {
        "pom.xml",
        "build.gradle",
        "build.gradle.kts",
        "settings.gradle",
        "settings.gradle.kts",
        "gradlew",
        "mvnw",
        ".classpath",
        ".project",
        ".git",
    },
    cmd = build_cmd(uv.cwd()),
    filetypes = { "java" },
    init_options = {
        extendedClientCapabilities = {
            classFileContentsSupport = true,
            generateToStringPromptSupport = true,
            hashCodeEqualsPromptSupport = true,
            advancedExtractRefactoringSupport = true,
            advancedOrganizeImportsSupport = true,
            generateConstructorsPromptSupport = true,
            generateDelegateMethodsPromptSupport = true,
            moveRefactoringSupport = true,
            overrideMethodsPromptSupport = true,
            executeClientCommandSupport = true,
            inferSelectionSupport = {
                "extractMethod",
                "extractVariable",
                "extractConstant",
                "extractVariableAllOccurrence",
            },
        },
    },
    before_init = function(_, config)
        if not config then
            return
        end
        local root_dir = config and config.root_dir or uv.cwd()
        config.cmd = build_cmd(root_dir)
        config.settings = java_settings_for_root(root_dir)
    end,
    settings = java_settings_for_root(uv.cwd()),
}
