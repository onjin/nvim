local fs = vim.fs

if not _G.java_env_set then
    _G.java_env_set = true
    vim.schedule(function()
        local lsp_cfg = require("config.lsp")
        if lsp_cfg.is_enabled("java", "jdtls") then
            vim.lsp.enable("jdtls")
        end
    end)
end

local function read_file(path)
    local ok, lines = pcall(vim.fn.readfile, path)
    if not ok then
        return nil
    end
    return table.concat(lines, "\n")
end

local function has_maven_spotless(root_dir)
    local pom = fs.joinpath(root_dir, "pom.xml")
    local content = read_file(pom)
    return content and content:match("<artifactId>%s*spotless%-maven%-plugin%s*</artifactId>") ~= nil
end

local function has_gradle_spotless(root_dir)
    for _, name in ipairs({ "build.gradle", "build.gradle.kts" }) do
        local path = fs.joinpath(root_dir, name)
        local content = read_file(path)
        if content and (content:match("id%s*[%(%\"]%s*['\"]com%.diffplug%.spotless['\"]")
            or content:match("apply%s+plugin:%s*['\"]com%.diffplug%.spotless['\"]")
            or content:match("spotless%s*{")) then
            return true, path
        end
    end
    return false, nil
end

local function find_spotless_runner(bufnr)
    local file = vim.api.nvim_buf_get_name(bufnr)
    if file == "" then
        return nil
    end

    local root_dir = vim.fs.root(file, {
        "pom.xml",
        "build.gradle",
        "build.gradle.kts",
        "settings.gradle",
        "settings.gradle.kts",
        "mvnw",
        "gradlew",
        ".git",
    })
    if not root_dir then
        return nil
    end

    if has_maven_spotless(root_dir) then
        local mvnw = fs.joinpath(root_dir, "mvnw")
        local cmd
        if vim.fn.executable(mvnw) == 1 then
            cmd = { mvnw, "spotless:apply" }
        else
            cmd = { "mvn", "spotless:apply" }
        end
        return {
            root_dir = root_dir,
            cmd = cmd,
            label = "spotless-maven-plugin",
        }
    end

    local has_gradle = has_gradle_spotless(root_dir)
    if has_gradle then
        local gradlew = fs.joinpath(root_dir, "gradlew")
        local cmd
        if vim.fn.executable(gradlew) == 1 then
            cmd = { gradlew, "spotlessApply" }
        else
            cmd = { "gradle", "spotlessApply" }
        end
        return {
            root_dir = root_dir,
            cmd = cmd,
            label = "spotless",
        }
    end

    return nil
end

local function java_format()
    local bufnr = vim.api.nvim_get_current_buf()
    local spotless = find_spotless_runner(bufnr)
    if not spotless then
        vim.lsp.buf.format()
        return
    end

    if vim.bo[bufnr].modified then
        vim.cmd.write()
    end

    vim.notify(("[Java] Running %s..."):format(spotless.label), vim.log.levels.INFO)
    vim.system(spotless.cmd, { cwd = spotless.root_dir, text = true }, function(result)
        vim.schedule(function()
            if result.code == 0 then
                if vim.api.nvim_buf_is_valid(bufnr) then
                    vim.cmd(("checktime %d"):format(bufnr))
                end
                vim.notify("[Java] Spotless apply finished", vim.log.levels.INFO)
                return
            end

            local stderr = (result.stderr or ""):gsub("%s+$", "")
            local stdout = (result.stdout or ""):gsub("%s+$", "")
            local message = stderr ~= "" and stderr or stdout
            if message == "" then
                message = ("command failed with exit code %d"):format(result.code)
            end
            vim.notify(("[Java] Spotless apply failed: %s"):format(message), vim.log.levels.ERROR)
        end)
    end)
end

vim.keymap.set("n", "glf", java_format, {
    buffer = true,
    silent = true,
    noremap = true,
    desc = "[Java] Format via Spotless when configured",
})
