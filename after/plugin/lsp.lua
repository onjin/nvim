local lsp_global_keymaps = {
}

local lsp_capabilities_keymaps = {
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
        { mode = "n", lhs = "<leader>e",  rhs = vim.diagnostic.open_float },
        { mode = "n", lhs = "<leader>dl", rhs = "<cmd>Pick diagnostic scope='current'<cr>", desc = "List diagnostics (buffer)" },
        { mode = "n", lhs = "<leader>dL", rhs = "<cmd>Pick diagnostic scope='all'<cr>",     desc = "List diagnostics (all)" },

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
        for method, maps in pairs(lsp_capabilities_keymaps) do
            if client.supports_method and client:supports_method(method) then
                for _, m in ipairs(maps) do map(m) end
            end
        end

        -- maps that don't depend on a capability
        for _, m in ipairs(lsp_global_keymaps) do map(m) end

        -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
        if not client:supports_method('textDocument/willSaveWaitUntil')
            and client:supports_method('textDocument/formatting') then
            vim.api.nvim_create_autocmd('BufWritePre', {
                group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
                buffer = args.buf,
                callback = function()
                    vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
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
