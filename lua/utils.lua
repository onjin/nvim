-- lua/utils.lua
local M = {}

-- Map string → vim.log.levels
local NAME_TO_LEVEL = {
    TRACE = vim.log.levels.TRACE,
    DEBUG = vim.log.levels.DEBUG,
    INFO  = vim.log.levels.INFO,
    WARN  = vim.log.levels.WARN,
    ERROR = vim.log.levels.ERROR,
    OFF   = math.huge, -- effectively disables output
}

local function normalize_level(lvl)
    if type(lvl) == "number" then return lvl end
    if type(lvl) == "string" then
        local key = lvl:upper():gsub("^%s+", ""):gsub("%s+$", "")
        return NAME_TO_LEVEL[key]
    end
    return nil
end

-- Minimum level: default ERROR, overridable by NVIM_LOG_LEVEL
local _min_level = (function()
    local from_env = normalize_level(vim.env.NVIM_LOG_LEVEL or "ERROR")
    return from_env or vim.log.levels.ERROR
end)()

---Get current minimum log level.
---@return integer
function M.get_log_level()
    return _min_level
end

---Set minimum log level at runtime.
---@param lvl integer|string
function M.set_log_level(lvl)
    _min_level = normalize_level(lvl) or _min_level
end

-- Internal: stringify tables nicely
local function to_string(x)
    if type(x) == "table" then
        return vim.inspect(x)
    end
    return tostring(x)
end

---Log a message if its level >= current minimum.
---Default message level is INFO.
---@param msg any
---@param level? integer|string
---@param opts? table  -- passed to vim.notify (e.g. { title = "MyMod" })
function M.zlog(msg, level, opts)
    local lvl = normalize_level(level or vim.log.levels.INFO) or vim.log.levels.INFO
    if lvl < _min_level then return end
    vim.notify(to_string(msg), lvl, opts or {})
end

---Printf-style helper.
---@param level integer|string
---@param fmt string
---@param ... any
function M.zlogf(level, fmt, ...)
    local lvl = normalize_level(level or vim.log.levels.INFO) or vim.log.levels.INFO
    if lvl < _min_level then return end
    vim.notify(string.format(fmt, ...), lvl)
end

-- Convenience shorthands (optional)
function M.log_debug(msg, opts) M.zlog(msg, "DEBUG", opts) end

function M.log_info(msg, opts) M.zlog(msg, "INFO", opts) end

function M.log_warn(msg, opts) M.zlog(msg, "WARN", opts) end

function M.log_error(msg, opts) M.zlog(msg, "ERROR", opts) end

M.setkey = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { desc = desc, noremap = true, silent = true })
end

return M
