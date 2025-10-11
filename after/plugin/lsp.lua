vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('my.lsp', {}),
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

        if client:supports_method('textDocument/implementation') then
            -- Create a keymap for vim.lsp.buf.implementation ...
        end
        -- -- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
        -- if client:supports_method('textDocument/completion') then
        --     -- Optional: trigger autocompletion on EVERY keypress. May be slow!
        --     -- local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
        --     -- client.server_capabilities.completionProvider.triggerCharacters = chars
        --     vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = false })
        -- end
        if client:supports_method('textDocument/publishDiagnostic') then
            vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
        end
        if client:supports_method('textDocument/formatting') then
            vim.keymap.set("n", "glf", vim.lsp.buf.format)
        end
        -- Auto-format ("lint") on save.
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
                    vim.notify("[lsp] " .. name .. ": restarted")
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
