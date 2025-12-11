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
local cmd = { "jdtls" }

if lombok_jar then
    table.insert(cmd, "--jvm-arg=-javaagent:" .. lombok_jar)
    table.insert(cmd, "--jvm-arg=-Xbootclasspath/a:" .. lombok_jar)
else
    warn_missing_lombok()
end

return {
    root_markers = { ".git", "gradlew", "mvnw" },
    cmd = cmd,
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
    settings = {
        java = vim.empty_dict(),
    },
}
