local lsp_cfg = require("config.lsp")

local M = {}

local function has_executable(cmd)
    return vim.fn.executable(cmd) == 1
end

local function server_available(server, has_uvx)
    if not lsp_cfg.is_enabled("python", server) then
        return false
    end
    if server == "basedpyright" then
        return has_executable("basedpyright-langserver")
    elseif server == "ruff" then
        return has_uvx or has_executable("ruff")
    elseif server == "ty" then
        return has_uvx or has_executable("ty")
    end
    return false
end

local function iter_clients_by_name(name)
    if not name then
        return {}
    end
    if vim.lsp.get_clients then
        return vim.lsp.get_clients({ name = name }) or {}
    end
    local clients = {}
    for _, client in pairs(vim.lsp.get_active_clients()) do
        if client.name == name then
            table.insert(clients, client)
        end
    end
    return clients
end

local function stop_server(name)
    for _, client in ipairs(iter_clients_by_name(name)) do
        client:stop(true)
    end
end

local function format_state_message(state)
    local type_server = state.type_server or "none"
    local diag = ""
    if state.diagnostics and state.diagnostics ~= state.type_server then
        diag = (" (diagnostics: %s)"):format(state.diagnostics)
    end
    return ("Python type server: %s%s"):format(type_server, diag)
end

function M.compute_state()
    local has_uvx = has_executable("uvx")
    local available = {
        basedpyright = server_available("basedpyright", has_uvx),
        ruff = server_available("ruff", has_uvx),
        ty = server_available("ty", has_uvx),
    }

    local preferred_type = lsp_cfg.get_python_type_server()
    local fallback = preferred_type == "ty" and "basedpyright" or "ty"
    local type_server = nil
    if preferred_type and available[preferred_type] then
        type_server = preferred_type
    elseif fallback and available[fallback] then
        type_server = fallback
    elseif available.basedpyright then
        type_server = "basedpyright"
    elseif available.ty then
        type_server = "ty"
    end

    local diagnostics = nil
    if available.ruff then
        diagnostics = "ruff"
    else
        diagnostics = type_server
    end

    return {
        available = available,
        diagnostics = diagnostics,
        type_server = type_server,
    }
end

function M.set_state(state)
    M._state = state
end

function M.apply_state(state, opts)
    opts = opts or {}
    state = state or M.compute_state()
    local prev_state = M._state
    local prev_servers = prev_state and M.servers_to_enable(prev_state) or {}
    local next_servers = M.servers_to_enable(state)
    local keep = {}
    for _, server in ipairs(next_servers) do
        keep[server] = true
    end
    for _, server in ipairs(prev_servers) do
        if not keep[server] then
            stop_server(server)
        end
    end
    if not opts.skip_enable then
        for _, server in ipairs(next_servers) do
            vim.lsp.enable(server)
        end
    end
    M.set_state(state)
    return state
end

function M.get_state()
    if not M._state then
        M._state = M.compute_state()
    end
    return M._state
end

function M.servers_to_enable(state)
    state = state or M.get_state()
    local servers = {}
    if state.type_server then
        table.insert(servers, state.type_server)
    end
    if state.diagnostics and state.diagnostics ~= state.type_server then
        table.insert(servers, state.diagnostics)
    end
    return servers
end

function M.should_client_publish_diagnostics(client_name)
    local diag = (M.get_state() or {}).diagnostics
    if not diag then
        return true
    end
    return diag == client_name
end

local function disable_publish_diagnostics(client)
    client.server_capabilities = client.server_capabilities or {}
    client.server_capabilities.diagnosticProvider = false
    client.handlers = client.handlers or {}
    client.handlers["textDocument/publishDiagnostics"] = function() end
end

function M.apply_diagnostics_policy(client)
    if not M.should_client_publish_diagnostics(client.name) then
        if client.name ~= "ty" then -- ty is not duplicating with ruff
            vim.notify("disabled diagnosics from " .. client.name)
            disable_publish_diagnostics(client)
        end
    end
end

function M.use_type_server(server)
    local ok, err = lsp_cfg.set_python_type_server(server)
    if not ok then
        return false, err
    end
    local state = M.apply_state(M.compute_state())
    if server ~= nil and not state.available[server] then
        local current = state.type_server or "none"
        return false, ("Python type server '%s' is not available (using %s)."):format(server, current)
    end
    return true, format_state_message(state)
end

function M.toggle_type_server()
    local state = M.get_state()
    local target = "ty"
    if state.type_server == "ty" then
        target = "basedpyright"
    end
    local ok, msg = M.use_type_server(target)
    if not ok then
        return false, msg
    end
    return true, msg
end

return M
