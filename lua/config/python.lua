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
        disable_publish_diagnostics(client)
    end
end

return M
