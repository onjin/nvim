local M = {}
local ms = vim.lsp.protocol.Methods

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities({}, false))
local default_position_encoding = "utf-16"
capabilities.general = capabilities.general or {}
capabilities.general.positionEncodings = { default_position_encoding }
capabilities.offsetEncoding = { default_position_encoding }

if vim.lsp.config then
    vim.lsp.config("*", { capabilities = capabilities })
else
    vim.lsp.defaults = vim.lsp.defaults or {}
    vim.lsp.defaults.capabilities = vim.tbl_deep_extend("force", vim.lsp.defaults.capabilities or {}, capabilities)
end

M.lsp_global_keymaps = {
    { mode = "n", lhs = "gA", rhs = "<cmd>LspAttach<cr>", desc = "[LSP] Pick & Attach LSP" },
    { mode = "n", lhs = "gD", rhs = "<cmd>LspDetach<cr>", desc = "[LSP] Pick & Detach LSP" },
}
M.workspace_symbols_for = function(expand_key)
    return function()
        local query = vim.fn.expand(expand_key)
        if query and query ~= "" then
            vim.lsp.buf.workspace_symbol(query)
        end
    end
end

local function sanitize_qf_items(items)
    local valid = {}
    local dropped = 0

    for _, item in ipairs(items or {}) do
        local filename = item.filename
        local lnum = item.lnum

        if not filename or filename == "" or type(lnum) ~= "number" or lnum < 1 then
            dropped = dropped + 1
        else
            local bufnr = vim.fn.bufadd(filename)
            if vim.fn.bufloaded(bufnr) == 0 then
                vim.fn.bufload(bufnr)
            end

            local line_count = vim.api.nvim_buf_line_count(bufnr)
            if lnum <= line_count then
                table.insert(valid, item)
            else
                dropped = dropped + 1
            end
        end
    end

    return valid, dropped
end

local function location_uri(location)
    return location and (location.uri or location.targetUri) or nil
end

local function location_range(location)
    return location and (location.range or location.targetSelectionRange or location.targetRange) or nil
end

local function normalize_locations(result)
    if not result then
        return {}
    end
    return vim.islist(result) and result or { result }
end

local function uri_label(uri)
    if not uri or uri == "" then
        return "[unknown]"
    end
    if vim.startswith(uri, "file://") then
        return vim.fn.fnamemodify(vim.uri_to_fname(uri), ":~:.")
    end
    if vim.startswith(uri, "jdt://") then
        return uri:match("/([^/?]+%.java)") or uri
    end
    return uri
end

local function position_to_col(line, character, offset_encoding)
    local ok, col = pcall(vim.str_byteindex, line or "", offset_encoding or "utf-16", character or 0, false)
    if ok and type(col) == "number" then
        return col
    end
    return 0
end

local function set_window_cursor_from_range(win, bufnr, range, offset_encoding)
    local line_count = vim.api.nvim_buf_line_count(bufnr)
    if line_count < 1 then
        return
    end

    local start = range and range.start or { line = 0, character = 0 }
    local lnum = math.max(1, math.min(line_count, (start.line or 0) + 1))
    local line = vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, false)[1] or ""
    local col = position_to_col(line, start.character or 0, offset_encoding)
    local max_col = #line

    vim.api.nvim_win_set_cursor(win, { lnum, math.max(0, math.min(col, max_col)) })
    vim._with({ win = win }, function()
        vim.cmd("normal! zv")
    end)
end

local function open_jdt_location(win, client, location)
    local uri = location_uri(location)
    local range = location_range(location)
    local response, err = client:request_sync("java/classFileContents", { uri = uri }, 2000, 0)
    if not response then
        vim.notify(("[jdtls] Failed to load class contents: %s"):format(err or "unknown error"), vim.log.levels.WARN)
        return
    end
    if response.err then
        local message = response.err.message or vim.inspect(response.err)
        vim.notify(("[jdtls] Failed to load class contents: %s"):format(message), vim.log.levels.WARN)
        return
    end

    local text = response.result
    if type(text) ~= "string" or text == "" then
        vim.notify("[jdtls] Empty class contents returned for location", vim.log.levels.WARN)
        return
    end

    local bufnr = vim.fn.bufnr(uri)
    if bufnr == -1 then
        bufnr = vim.api.nvim_create_buf(true, true)
        vim.api.nvim_buf_set_name(bufnr, uri)
    end

    local lines = vim.split(text, "\n", { plain = true, trimempty = false })
    vim.bo[bufnr].modifiable = true
    vim.bo[bufnr].buftype = "nofile"
    vim.bo[bufnr].bufhidden = "hide"
    vim.bo[bufnr].swapfile = false
    vim.bo[bufnr].filetype = "java"
    vim.bo[bufnr].readonly = false
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
    vim.bo[bufnr].modifiable = false
    vim.bo[bufnr].readonly = true

    vim.api.nvim_win_set_buf(win, bufnr)
    set_window_cursor_from_range(win, bufnr, range, client.offset_encoding)
end

local function open_file_location(win, client, location)
    local uri = location_uri(location)
    local range = location_range(location)
    local bufnr = vim.uri_to_bufnr(uri)

    vim.fn.bufload(bufnr)
    vim.bo[bufnr].buflisted = true
    vim.api.nvim_win_set_buf(win, bufnr)
    set_window_cursor_from_range(win, bufnr, range, client.offset_encoding)
end

local function open_location(win, entry)
    local uri = location_uri(entry.location)
    if not uri then
        vim.notify("[LSP] Location did not include a URI", vim.log.levels.WARN)
        return
    end
    if vim.startswith(uri, "jdt://") and entry.client.name == "jdtls" then
        open_jdt_location(win, entry.client, entry.location)
        return
    end
    if vim.startswith(uri, "file://") then
        open_file_location(win, entry.client, entry.location)
        return
    end
    vim.notify(("[LSP] Unsupported location URI: %s"):format(uri), vim.log.levels.WARN)
end

local function jump_to_location_safely(method)
    return function()
        local bufnr = vim.api.nvim_get_current_buf()
        local win = vim.api.nvim_get_current_win()
        local clients = vim.lsp.get_clients({ method = method, bufnr = bufnr })
        if not next(clients) then
            vim.notify(vim.lsp._unsupported_method(method), vim.log.levels.WARN)
            return
        end

        local pending = #clients
        local matches = {}

        local function finish()
            if #matches == 0 then
                vim.notify("No locations found", vim.log.levels.INFO)
                return
            end

            if #matches == 1 then
                open_location(win, matches[1])
                return
            end

            vim.ui.select(matches, {
                prompt = "Select LSP location:",
                format_item = function(item)
                    local uri = location_uri(item.location)
                    local range = location_range(item.location)
                    local lnum = range and range.start and (range.start.line + 1) or 1
                    return ("%s:%d [%s]"):format(uri_label(uri), lnum, item.client.name)
                end,
            }, function(choice)
                if choice then
                    open_location(win, choice)
                end
            end)
        end

        for _, client in ipairs(clients) do
            local params = vim.lsp.util.make_position_params(win, client.offset_encoding)
            client:request(method, params, function(err, result)
                if err then
                    vim.notify(
                        ("[LSP] %s request failed for %s: %s"):format(method, client.name, err.message or vim.inspect(err)),
                        vim.log.levels.WARN
                    )
                else
                    for _, location in ipairs(normalize_locations(result)) do
                        table.insert(matches, { client = client, location = location })
                    end
                end

                pending = pending - 1
                if pending == 0 then
                    finish()
                end
            end, bufnr)
        end
    end
end

local function list_references_safely()
    vim.lsp.buf.references(nil, {
        on_list = function(list)
            local items, dropped = sanitize_qf_items(list.items)
            if #items == 0 then
                if dropped > 0 then
                    vim.notify(
                        ("[LSP] References result only contained invalid locations (%d dropped)"):format(dropped),
                        vim.log.levels.WARN
                    )
                else
                    vim.notify("No references found", vim.log.levels.INFO)
                end
                return
            end

            vim.fn.setqflist({}, " ", {
                title = list.title,
                items = items,
                context = list.context,
            })
            vim.cmd("botright copen")

            if dropped > 0 then
                vim.notify(
                    ("[LSP] Dropped %d invalid reference location(s) from server response"):format(dropped),
                    vim.log.levels.WARN
                )
            end
        end,
    })
end

M.lsp_capabilities_keymaps = {
    ["textDocument/definition"] = {
        { mode = "n", lhs = "grd", rhs = jump_to_location_safely(ms.textDocument_definition), desc = "[LSP] Go to Definition" },
    },
    ["textDocument/declaration"] = {
        { mode = "n", lhs = "grD", rhs = jump_to_location_safely(ms.textDocument_declaration), desc = "[LSP] Declaration" },
    },
    ["textDocument/hover"] = {
        { mode = "n", lhs = "K", rhs = vim.lsp.buf.hover, desc = "[LSP] Hover Documentation" },
    },
    ["callHierarchy/incomingCalls"] = {
        { mode = "n", lhs = "grC", rhs = vim.lsp.buf.incoming_calls, desc = "[LSP] Incoming Calls" },
    },
    ["callHierarchy/outgoingCalls"] = {
        { mode = "n", lhs = "grc", rhs = vim.lsp.buf.outgoing_calls, desc = "[LSP] Outgoing Calls" },
    },

    ["textdocument/codeaction"] = {
        { mode = "n", lhs = "gra", rhs = vim.lsp.buf.code_action, desc = "[LSP] Code Actions" },
    },
    ["textDocument/implementation"] = {
        { mode = "n", lhs = "gri", rhs = jump_to_location_safely(ms.textDocument_implementation), desc = "[LSP] Go to the implementations" },
    },
    ["textDocument/rename"] = {
        { mode = "n", lhs = "grn", rhs = vim.lsp.buf.rename, desc = "[LSP] Rename" },
    },
    ["textDocument/references"] = {
        { mode = "n", lhs = "grr", rhs = list_references_safely, desc = "[LSP] Show references" },
    },
    ["textDocument/typeDefinition"] = {
        { mode = "n", lhs = "grt", rhs = jump_to_location_safely(ms.textDocument_typeDefinition), desc = "[LSP] Type Definition" },
    },
    ["textDocument/documentSymbol"] = {
        { mode = "n", lhs = "grO", rhs = vim.lsp.buf.document_symbol,        desc = "[LSP] Document Symbols" },
        { mode = "n", lhs = "grs", rhs = M.workspace_symbols_for("<cword>"), desc = "Workspace symbols for word under cursor" },

    },
    ["textDocument/signatureHelp"] = {
        { mode = "i", lhs = "<C-s>", rhs = vim.lsp.buf.signature_help, desc = "[LSP] Signature Help" },
    },
    ["textDocument/formatting"] = {
        { mode = "n", lhs = "glf", rhs = vim.lsp.buf.format, desc = "[LSP] Code Format" },
    },
    ["textDocument/publishDiagnostic"] = {
        { mode = "n", lhs = "<leader>e", rhs = vim.diagnostic.open_float, desc = "[LSP] Open floating diagnostics" },
        {
            mode = "n",
            lhs = "<leader>dl",
            rhs = function()
                local ok, Snacks = pcall(require, "snacks")
                if ok then
                    Snacks.picker.diagnostics_buffer()
                else
                    vim.notify("Snacks diagnostics picker is not available", vim.log.levels.WARN)
                end
            end,
            desc = "[LSP] List diagnostics (buffer)",
        },
        {
            mode = "n",
            lhs = "<leader>dL",
            rhs = function()
                local ok, Snacks = pcall(require, "snacks")
                if ok then
                    Snacks.picker.diagnostics()
                else
                    vim.notify("Snacks diagnostics picker is not available", vim.log.levels.WARN)
                end
            end,
            desc = "[LSP] List diagnostics (all)",
        },
    },
}

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('my.lsp', {}),
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        local bufnr = args.buf

        -- small helper
        local function map(m)
            vim.keymap.set(m.mode, m.lhs, m.rhs, { buffer = bufnr, silent = true, noremap = true, desc = m.desc })
        end
        -- maps gated by capability
        for method, maps in pairs(M.lsp_capabilities_keymaps) do
            -- jdtls uses dynamic registration
            if (client.supports_method and client:supports_method(method)) or client.name == 'jdtls' then
                for _, m in ipairs(maps) do map(m) end
            end
        end

        -- maps that don't depend on a capability
        for _, m in ipairs(M.lsp_global_keymaps) do map(m) end

        -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
        if not client:supports_method('textDocument/willSaveWaitUntil')
            and client:supports_method('textDocument/formatting') then
            local bufnr = args.buf
            local group_name = ("my.lsp.format.%s.%d"):format(client.name:gsub("%W", "_"), bufnr)
            local group = vim.api.nvim_create_augroup(group_name, { clear = true })
            if vim.g.autoformat_on_save_enabled == true then
                vim.api.nvim_create_autocmd('BufWritePre', {
                    group = group,
                    buffer = bufnr,
                    callback = function()
                        if not vim.lsp.get_client_by_id(client.id) then return end
                        vim.lsp.buf.format({ bufnr = bufnr, id = client.id, timeout_ms = 1000 })
                    end,
                })
            end
        end
    end,
})

vim.api.nvim_create_user_command("LspRestart", function()
    local detach_clients = {}
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
        client:stop(true)
        if vim.tbl_count(client.attached_buffers) > 0 then
            detach_clients[client.name] = { client, vim.lsp.get_buffers_by_client_id(client.id) }
        end
    end
    ---@diagnostic disable-next-line undefined-field
    local timer = vim.uv.new_timer()
    timer:start(
        100,
        50,
        vim.schedule_wrap(function()
            for name, client in pairs(detach_clients) do
                local client_id = vim.lsp.start(client[1].config, { attach = false })
                if client_id then
                    for _, buf in ipairs(client[2]) do
                        vim.lsp.buf_attach_client(buf, client_id)
                    end
                    vim.notify("[LSP] " .. name .. ": restarted")
                end
                detach_clients[name] = nil
            end
            if next(detach_clients) == nil and not timer:is_closing() then
                timer:close()
            end
        end)
    )
end, {
    desc = "Restart all the LSP clients attached to the current buffer",
})

-- Log {{{
vim.api.nvim_create_user_command("LspLog", function()
    vim.cmd.vsplit(vim.lsp.log.get_filename())
end, { desc = "Get all the LSP logs" })
-- }}}

-- Info {{{
vim.api.nvim_create_user_command("LspInfo", function()
    vim.cmd("silent checkhealth vim.lsp")
end, { desc = "Get all the information about all LSP attached" })
-- }}}


local function get_buf_clients(bufnr)
    bufnr = bufnr or 0
    local ok_get_clients = vim.lsp.get_clients ~= nil
    if ok_get_clients then
        return vim.lsp.get_clients({ bufnr = bufnr })
    else
        -- Neovim <0.10 fallback
        local attached = {}
        for _, c in pairs(vim.lsp.get_active_clients()) do
            if c.attached_buffers and c.attached_buffers[bufnr] then
                table.insert(attached, c)
            end
        end
        return attached
    end
end


--- Pick a matching server (by filetype) and attach/start it for the current buffer.
function M.attach_picker()
    local bufnr = 0
    local ft = vim.bo[bufnr].filetype
    if not ft or ft == "" then
        vim.notify("No filetype for current buffer", vim.log.levels.WARN)
        return
    end

    -- find servers whose default_config.filetypes contains current ft
    local candidates = {
        { label = "basedpyright",  name = "basedpyright" },
        { label = "ruff",          name = "ruff" },
        { label = "rust-analyzer", name = "rust_analyzer" },
        { label = "terraform-ls",  name = "terraformls" },
        { label = "lua_ls",        name = "lua_ls" },
        { label = "ty",            name = "ty" },
        { label = "jdtls",         name = "jdtls" },
    }


    -- Don’t suggest servers already attached
    local attached_names = {}
    for _, c in ipairs(get_buf_clients(bufnr)) do attached_names[c.name] = true end
    local display = {}
    for _, item in ipairs(candidates) do
        local mark = attached_names[item.name] and "✓ " or "  "
        table.insert(display, mark .. item.label)
    end

    vim.ui.select(display, { prompt = "Attach LSP to buffer:" }, function(choice, idx)
        if not choice then return end
        local picked = candidates[idx]
        vim.lsp.enable(picked.name)
    end)
end

--- Pick an attached client and detach it from current buffer.
function M.detach_picker()
    local bufnr = 0
    local clients = get_buf_clients(bufnr)
    if #clients == 0 then
        vim.notify("No LSP clients attached to this buffer", vim.log.levels.INFO)
        return
    end
    local items = {}
    for _, c in ipairs(clients) do
        local root = c.config and c.config.root_dir or ""
        local capn = (c.name or ("id:" .. c.id))
        local label = root ~= "" and (capn .. "  —  " .. root) or capn
        table.insert(items, label)
    end

    vim.ui.select(items, { prompt = "Detach LSP client from buffer:" }, function(choice, idx)
        if not choice then return end
        local client = clients[idx]
        vim.lsp.buf_detach_client(bufnr, client.id) -- buffer-local detach
        -- If you prefer to stop the whole client (all buffers), use:
        -- client.stop(true)
    end)
end

vim.api.nvim_create_user_command("LspAttach", function()
    M.attach_picker()
end, { desc = "Pick & attach matching LSP server" })

vim.api.nvim_create_user_command("LspDettach", function()
    M.detach_picker()
end, { desc = "Pick & attach matching LSP server" })

do
    local python_cfg = require("config.python")
    vim.api.nvim_create_user_command("PythonTypeServer", function(opts)
        local arg = opts.args
        local ok, msg
        if arg == "" then
            ok, msg = python_cfg.toggle_type_server()
        elseif arg == "default" then
            ok, msg = python_cfg.use_type_server(nil)
        else
            ok, msg = python_cfg.use_type_server(arg)
        end
        local level = ok and vim.log.levels.INFO or vim.log.levels.ERROR
        vim.notify(msg, level)
    end, {
        nargs = "?",
        complete = function()
            return { "ty", "basedpyright", "default" }
        end,
        desc = "Toggle or set the preferred Python type server (ty/basedpyright)",
    })
end

return M
