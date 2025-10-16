-- Engines for loading plugin specification expressed in lazy.nvim schema.
-- Usage:
--   local spec = require("plugins.spec")
--   require("plugins.engine").execute(spec)            -- defaults to lazy.nvim
--   require("plugins.engine").execute("mini-deps", spec)
--
local U = require('utils')

local Engine = {}

-- ===== Helpers =====

local function split_owner_repo(src)
    local owner, repo = src:match("^([^/]+)/(.+)$")
    return owner, repo or src
end

local function plug_name(plugin)
    if plugin.name then return plugin.name end
    local _, repo = split_owner_repo(plugin.source)
    return repo
end

local function run_init(plugin)
    if type(plugin.init) ~= "function" then return end
    local ok, err = pcall(plugin.init, plugin)
    if not ok then
        vim.notify(("Error in init for %s: %s"):format(plugin.source, err), vim.log.levels.ERROR)
    end
end

local function call_setup_or_config(plugin)
    local module_name = plugin.module or plug_name(plugin):gsub("%.nvim$", "")
    U.log_debug('[plugins][' .. module_name .. '] loading')

    if type(plugin.config) == "function" then
        U.log_debug('[plugins][' .. module_name .. '] calling .config')
        local okc, err = pcall(plugin.config, plugin, plugin.opts)
        if not okc then
            vim.notify("Error in config for " .. plugin.source .. ": " .. err, vim.log.levels.ERROR)
        end
        return
    end

    if plugin.has_setup == false then
        return
    end

    local ok, mod = pcall(require, module_name)
    U.log_debug('[plugins][' .. module_name .. '] calling require')
    if not ok then
        if plugin.opts then
            vim.notify(("No Lua module for %s (require('%s')); ignoring opts")
                :format(plugin.source, module_name), vim.log.levels.WARN)
        end
        return
    end

    if type(mod.setup) == "function" then
        U.log_debug('[plugins][' .. module_name .. '] calling setup')
        local oks, err = pcall(mod.setup, plugin.opts or {})
        if not oks then
            vim.notify("Error in setup for " .. plugin.source .. ": " .. err, vim.log.levels.ERROR)
        end
        return
    end

    if plugin.opts then
        vim.notify(("Module %s has no setup(); opts ignored for %s")
            :format(module_name, plugin.source), vim.log.levels.WARN)
    end
end

local function notify_unsupported(plugin, unsupported)
    if #unsupported == 0 then return end
    local name = plugin.name or plugin.source
    vim.schedule(function()
        vim.notify(
            ("mini-deps engine: %s uses unsupported fields: %s")
            :format(name, table.concat(unsupported, ", ")),
            vim.log.levels.WARN
        )
    end)
end

local function normalize_lazy_item(entry)
    if type(entry) == "string" then
        return { source = entry }
    end

    if type(entry) ~= "table" then
        vim.notify("Invalid plugin spec entry: expected table or string", vim.log.levels.ERROR)
        return nil
    end

    local plugin = vim.deepcopy(entry)
    plugin.source = plugin[1] or plugin.source
    plugin[1] = nil

    if not plugin.source then
        vim.notify("Plugin spec entry is missing repository string", vim.log.levels.ERROR)
        return nil
    end

    return plugin
end

local function evaluate_condition(fn, plugin, field, unsupported)
    if type(fn) == "boolean" then
        return fn
    end
    if type(fn) ~= "function" then
        table.insert(unsupported, field .. "<" .. type(fn) .. ">")
        return true
    end
    local ok, result = pcall(fn, plugin)
    if not ok then
        vim.notify(("Error evaluating %s for %s: %s"):format(field, plugin.source, result), vim.log.levels.ERROR)
        return false
    end
    return not not result
end

local function plugin_is_enabled(plugin, unsupported)
    if plugin.enabled ~= nil then
        if not evaluate_condition(plugin.enabled, plugin, "enabled", unsupported) then
            return false
        end
    end
    if plugin.cond ~= nil then
        if not evaluate_condition(plugin.cond, plugin, "cond", unsupported) then
            return false
        end
    end
    return true
end

local function extract_dependency_sources(plugin, unsupported)
    if plugin.dependencies == nil then return nil end

    local sources = {}
    for _, dep in ipairs(plugin.dependencies) do
        local dep_type = type(dep)
        if dep_type == "string" then
            table.insert(sources, dep)
        elseif dep_type == "table" then
            local dep_source = dep[1] or dep.source
            if type(dep_source) == "string" then
                table.insert(sources, dep_source)
            else
                table.insert(unsupported, "dependency<missing source>")
            end
        else
            table.insert(unsupported, "dependency<" .. dep_type .. ">")
        end
    end

    return sources
end

local function minideps_node_from_lazy(plugin, unsupported)
    local node = {
        source = plugin.source,
        name = plugin.name,
    }

    if plugin.branch then node.checkout = plugin.branch end
    if plugin.tag then node.tag = plugin.tag end
    if plugin.commit then node.commit = plugin.commit end

    local hooks = nil
    if plugin.build ~= nil then
        if type(plugin.build) == "function" then
            hooks = hooks or {}
            hooks.post_install = function(ctx)
                local ok, err = pcall(plugin.build, ctx)
                if not ok then
                    U.log_error(("build hook failed for %s: %s"):format(plugin.source, err))
                end
            end
        else
            table.insert(unsupported, "build<" .. type(plugin.build) .. ">")
        end
    end

    if hooks then node.hooks = hooks end

    return node
end

local function collect_unsupported_lazy_fields(plugin)
    local unsupported = {}
    local fields = { "event", "cmd", "keys", "ft", "priority", "version" }
    for _, field in ipairs(fields) do
        if plugin[field] ~= nil then
            table.insert(unsupported, field)
        end
    end
    return unsupported
end

-- ====== Engine: mini.deps ======

local function ensure_mini_nvim()
    local path_package = vim.fn.stdpath("data") .. "/site/"
    local mini_path = path_package .. "pack/deps/start/mini.nvim"
    if not vim.loop.fs_stat(mini_path) then
        vim.cmd('echo "Installing `mini.nvim`" | redraw')
        local cmd = { "git", "clone", "--filter=blob:none", "https://github.com/nvim-mini/mini.nvim", mini_path }
        vim.fn.system(cmd)
        vim.cmd("packadd mini.nvim | helptags ALL")
        vim.cmd('echo "Installed `mini.nvim`" | redraw')
    end
    require("mini.deps").setup({ path = { package = path_package } })
end

local function run_minideps(spec)
    ensure_mini_nvim()
    local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

    local normalized = {}
    for _, entry in ipairs(spec or {}) do
        local plugin = normalize_lazy_item(entry)
        if plugin then
            table.insert(normalized, plugin)
        end
    end

    local now_list, later_list = {}, {}
    for _, plugin in ipairs(normalized) do
        local unsupported = collect_unsupported_lazy_fields(plugin)
        if plugin_is_enabled(plugin, unsupported) then
            run_init(plugin)
            plugin.__unsupported = unsupported
            if plugin.lazy == false then
                table.insert(now_list, plugin)
            else
                table.insert(later_list, plugin)
            end
        else
            notify_unsupported(plugin, unsupported)
        end
    end

    local function process(list)
        for _, plugin in ipairs(list) do
            local unsupported = plugin.__unsupported or {}
            local deps = extract_dependency_sources(plugin, unsupported)
            if deps then
                for _, dep in ipairs(deps) do
                    add({ source = dep })
                end
            end

            add(minideps_node_from_lazy(plugin, unsupported))
            call_setup_or_config(plugin)
            notify_unsupported(plugin, unsupported)
            plugin.__unsupported = nil
        end
    end

    now(function() process(now_list) end)
    later(function() process(later_list) end)
end

-- ====== Engine: lazy.nvim ======

local function run_lazy(spec)
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable",
            lazypath,
        })
    end
    vim.opt.rtp:prepend(lazypath)

    require("lazy").setup(spec or {}, {
        ui = { border = "rounded" },
        checker = { enabled = false },
    })
end

-- ===== Public API =====

---Execute spec with selected engine.
---@param engine_name? '"mini-deps"'|'"lazy"'
---@param spec LazySpec|nil
function Engine.execute(engine_name, spec)
    if type(engine_name) ~= "string" then
        spec = engine_name
        engine_name = "lazy"
    end

    if engine_name == "mini-deps" then
        run_minideps(spec or {})
    elseif engine_name == "lazy" then
        run_lazy(spec or {})
    else
        vim.notify("Unknown plugin engine: " .. tostring(engine_name), vim.log.levels.ERROR)
    end
end

return Engine
