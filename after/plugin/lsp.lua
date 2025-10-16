local M = {}

local capabilities = vim.lsp.protocol.make_client_capabilities()
local has_blink, blink_cmp = pcall(require, "blink.cmp")
if has_blink then
    capabilities = blink_cmp.get_lsp_capabilities(capabilities)
end

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

M.lsp_capabilities_keymaps = {
    ["textDocument/definition"] = {
        { mode = "n", lhs = "grd", rhs = vim.lsp.buf.definition, desc = "[LSP] Go to Definition" },
    },
    ["textDocument/declaration"] = {
        { mode = "n", lhs = "grD", rhs = vim.lsp.buf.declaration, desc = "[LSP] Declaration" },
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
        { mode = "n", lhs = "gri", rhs = vim.lsp.buf.implementation, desc = "[LSP] Go to the implementations" },
    },
    ["textDocument/rename"] = {
        { mode = "n", lhs = "grn", rhs = vim.lsp.buf.rename, desc = "[LSP] Rename" },
    },
    ["textDocument/references"] = {
        { mode = "n", lhs = "grr", rhs = vim.lsp.buf.references, desc = "[LSP] Show references" },
    },
    ["textDocument/typeDefinition"] = {
        { mode = "n", lhs = "grt", rhs = vim.lsp.buf.type_definition, desc = "[LSP] Type Definition" },
    },
    ["textDocument/documentSymbol"] = {
        { mode = "n", lhs = "gO", rhs = vim.lsp.buf.document_symbol, desc = "[LSP] Document Symbols" },
    },
    ["textDocument/signatureHelp"] = {
        { mode = "i", lhs = "<C-s>", rhs = vim.lsp.buf.signature_help, desc = "[LSP] Signature Help" },
    },
    ["textDocument/formatting"] = {
        { mode = "n", lhs = "glf", rhs = vim.lsp.buf.format, desc = "[LSP] Code Format" },
    },
    ["textDocument/publishDiagnostic"] = {
        { mode = "n", lhs = "<leader>e",  rhs = vim.diagnostic.open_float,                  desc = "[LSP] Open floating diagnostics" },
        { mode = "n", lhs = "<leader>dl", rhs = "<cmd>Pick diagnostic scope='current'<cr>", desc = "[LSP] List diagnostics (buffer)" },
        { mode = "n", lhs = "<leader>dL", rhs = "<cmd>Pick diagnostic scope='all'<cr>",     desc = "[LSP] List diagnostics (all)" },
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
            if client.supports_method and client:supports_method(method) then
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
            vim.api.nvim_create_autocmd('BufWritePre', {
                group = group,
                buffer = bufnr,
                callback = function()
                    if not vim.lsp.get_client_by_id(client.id) then return end
                    vim.lsp.buf.format({ bufnr = bufnr, id = client.id, timeout_ms = 1000 })
                end,
            })
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
        { label = "basedpyright", name = "basedpyright" },
        { label = "ruff",         name = "ruff" },
        { label = "lua_ls",       name = "lua_ls" },
        { label = "ty",           name = "ty" },
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

return M
