-- lua/plugins/spe.lua engines: mini-deps | lazy | builtin
-- Usage:
--   local spec = require("plugins.spec")
--   require("plugins.engine").execute("mini-deps", spec)

local Engine = {}

-- ===== Helpers =====

local function split_owner_repo(src)
    local owner, repo = src:match("^([^/]+)/(.+)$")
    return owner, repo or src
end

local function plug_name(p)
    if p.name then return p.name end
    local _, repo = split_owner_repo(p.source)
    return repo
end

local function call_setup_or_config(p)
    -- If .setup is exported and opts are availabl -> call .setup(opts)
    -- If not, but p.config available -> call p.config()
    local ok, mod = pcall(require, plug_name(p))
    -- use `config` first, then try `setup` with `opts`
    if type(p.config) == "function" then
        local ok3, err = pcall(p.config)
        if not ok3 then
            vim.notify("Error in config for " .. p.source .. ": " .. err, vim.log.levels.ERROR)
        end
    elseif ok and type(mod.setup) == "function" then
        local ok2, err = pcall(mod.setup, p.opts or {})
        if not ok2 then
            vim.notify("Error in setup for " .. p.source .. ": " .. err, vim.log.levels.ERROR)
        end
    end
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

    -- "now" first
    now(function()
        for _, p in ipairs(spec) do
            if p.stage == "now" then
                -- Start with dependencies
                if p.depends then
                    for _, d in ipairs(p.depends) do
                        add({ source = d.source })
                    end
                end
                add({ source = p.source, name = p.name })
                call_setup_or_config(p)
            end
        end
    end)

    -- "later" after
    later(function()
        for _, p in ipairs(spec) do
            if p.stage ~= "now" then
                if p.depends then
                    for _, d in ipairs(p.depends) do
                        add({ source = d.source })
                    end
                end
                local node = { source = p.source, name = p.name }
                if p.pin and p.pin.checkout then
                    node.checkout = p.pin.checkout
                end
                add(node)
                call_setup_or_config(p)
            end
        end
    end)
end

-- ====== Engine: lazy.nvim ======

local function run_lazy(spec)
    -- bootstrap
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
            lazypath })
    end
    vim.opt.rtp:prepend(lazypath)

    local lazy_spec = {}
    for _, p in ipairs(spec) do
        local item = {
            p.source,
            name = p.name,
            dependencies = p.depends and vim.tbl_map(function(d) return d.source end, p.depends) or nil,
            config = p.config,
            opts = p.opts,
        }
        -- Mapowanie stage -> lazy/event
        if p.stage == "now" then
            item.lazy = false
        else
            item.lazy = true
            item.event = p.event or "VeryLazy"
        end
        if p.pin then
            if p.pin.checkout then item.branch = p.pin.checkout end
            if p.pin.tag then item.tag = p.pin.tag end
            if p.pin.commit then item.commit = p.pin.commit end
        end
        table.insert(lazy_spec, item)
    end

    require("lazy").setup(lazy_spec, {
        ui = { border = "rounded" },
        checker = { enabled = false },
    })
end

-- ====== Engine: builtin (packages + packadd) ======
-- Simple clone and :packadd; no update option (yet).
-- Stages "now" → start/, "later" → opt/ + packadd on VimEnter.
-- EXPERIMENTAL AS HELL

local function git_clone_if_missing(dst, src, checkout)
    if vim.loop.fs_stat(dst) then return end
    vim.fn.mkdir(dst, "p")
    local url = ("https://github.com/%s.git"):format(src)
    local ok = vim.fn.system({ "git", "clone", "--filter=blob:none", url, dst })
    if vim.v.shell_error ~= 0 then
        vim.notify("git clone failed for " .. src .. ": " .. tostring(ok), vim.log.levels.ERROR)
        return
    end
    if checkout then
        vim.fn.system({ "git", "-C", dst, "checkout", checkout })
    end
end

local function run_builtin(spec)
    local base = vim.fn.stdpath("data") .. "/site/pack/plugins"
    for _, p in ipairs(spec) do
        local sub = (p.stage == "now") and "start" or "opt"
        local owner, repo = split_owner_repo(p.source)
        local dst = ("%s/%s/%s"):format(base, sub, repo)
        git_clone_if_missing(dst, p.source, p.pin and p.pin.checkout or nil)

        -- Load & set
        if p.stage == "now" then
            vim.cmd(("packadd %s"):format(repo))
            call_setup_or_config(p)
        else
            -- call later: on VimEnter
            vim.api.nvim_create_autocmd("VimEnter", {
                once = true,
                callback = function()
                    vim.cmd(("packadd %s"):format(repo))
                    call_setup_or_config(p)
                end,
            })
        end
    end
end

-- ===== Public API =====

---Execute spec with selected engine.
---@param engine_name '"mini-deps"'|'"lazy"'|'"builtin"'
---@param spec table[]
function Engine.execute(engine_name, spec)
    if engine_name == "mini-deps" then
        run_minideps(spec)
    elseif engine_name == "lazy" then
        run_lazy(spec)
    elseif engine_name == "builtin" then
        run_builtin(spec)
    else
        vim.notify("Unknown plugin engine: " .. tostring(engine_name), vim.log.levels.ERROR)
    end
end

return Engine
