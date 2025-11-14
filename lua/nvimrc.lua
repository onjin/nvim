local NvimRC = {}
local H = {}

NvimRC.setup = function(config)
    _G.NvimRC = NvimRC
    config = H.setup_config(config)
    H.apply_config(config)
    H.create_user_commands(config)
    H.create_autocommands(config)
end

NvimRC.config = {
    file = ".nvimrc.ini",
    defaults = {
        ai_enabled = false,
        autoformat_on_save_enabled = false,
        colorscheme = "catppuccin-mocha",
    },
    debug = false,
}

NvimRC.loaded_variables = {}

H.default_config = vim.deepcopy(NvimRC.config)

H.setup_config = function(config)
    vim.validate { config = { config, "table", true } }
    config = vim.tbl_deep_extend("force", vim.deepcopy(H.default_config), config or {})

    vim.validate {
        file = { config.file, "string" },
        debug = { config.debug, "boolean" },
        defaults = { config.defaults, "table" },
    }

    return config
end

---@param config table
H.set_globals_from_ini = function(config)
    local ini_file = vim.fn.getcwd() .. "/" .. config.file
    H.log("loading ini file " .. ini_file)
    local variables = config.defaults

    if vim.fn.filereadable(ini_file) == 1 then
        variables = H.load_ini_file(ini_file)
        variables = H.merge_configs(config.defaults, variables)
    end
    H.set_global_variables(variables)
end

H.merge_configs = function(default_config, user_config)
    local merged = {}

    for key, value in pairs(default_config) do
        merged[key] = value
    end

    for key, value in pairs(user_config) do
        merged[key] = value
    end

    return merged
end

H.apply_config = function(config)
    NvimRC.config = config
    H.set_globals_from_ini(config)
end

H.run_hooks = function(config)
    vim.cmd.colorscheme(vim.g.colorscheme)
end

H.load_ini_file = function(file)
    local variables = {}
    for line in io.lines(file) do
        if not line:match "^%s*;" then
            local key, value = line:match "^%s*([^=]+)%s*=%s*(.-)%s*$"
            if key and value then
                key = H.trim(key)
                value = H.trim(value)
                local number_value = tonumber(value)
                if number_value then
                    value = number_value
                elseif value:lower() == "true" then
                    value = true
                elseif value:lower() == "false" then
                    value = false
                else
                    value = tostring(value)
                    if value:match "^'.*'$" or value:match '^".*"$' then
                        value = value:sub(2, -2)
                    end
                end
                variables[key] = value
            end
        end
    end
    return variables
end

H.log = function(msg, level, opts)
    if NvimRC.config.debug == true then
        vim.notify("NVimRC: " .. msg, level, opts)
    end
end

H.set_global_variables = function(variables)
    NvimRC.loaded_variables = {}
    for key, value in pairs(variables) do
        vim.g[key] = value
        NvimRC.loaded_variables[key] = value
        H.log("setting variable '" .. key .. "' => '" .. tostring(value) .. "'")
    end
end

H.create_user_commands = function(config)
    vim.api.nvim_create_user_command("NVRCVariables", function()
        H.create_floating_inspection_window(NvimRC.loaded_variables)
    end, {})
    vim.api.nvim_create_user_command("NVRCEdit", function()
        vim.cmd("edit " .. config.file)
    end, {})
    vim.api.nvim_create_user_command("NVRCApply", function()
        H.apply_config(NvimRC.config)
        H.run_hooks(NvimRC.config)
    end, {})
end

H.create_autocommands = function(config)
    vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
            H.log "run hooks"
            H.run_hooks(NvimRC.config)
        end,
    })
end

H.trim = function(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

H.create_floating_inspection_window = function(variables)
    local keys = {}
    for key in pairs(variables) do
        table.insert(keys, key)
    end
    table.sort(keys)

    local content = {}
    for _, key in ipairs(keys) do
        table.insert(content, string.format("%s = %s", key, tostring(variables[key])))
    end

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)

    local width = math.max(20, vim.fn.max(vim.tbl_map(function(line)
        return #line
    end, content)) + 2)
    local height = #content + 2
    local win_opts = {
        relative = "editor",
        width = width,
        height = height,
        row = (vim.o.lines - height) / 2,
        col = (vim.o.columns - width) / 2,
        style = "minimal",
        border = "rounded",
    }

    local win = vim.api.nvim_open_win(buf, true, win_opts)

    vim.api.nvim_buf_set_keymap(buf, "n", "q", ":close<CR>", { noremap = true, silent = true })
    vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
    vim.api.nvim_buf_set_option(buf, "modifiable", false)

    return win
end

return NvimRC
