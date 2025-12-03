return {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = { ".luarc.json", ".luarc.jsonc" },
    on_attach = function(client, buf_id)
        -- Reduce unnecessarily long list of completion triggers
        client.server_capabilities.completionProvider.triggerCharacters = { '.', ':', '#', '(' }
    end,
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT', path = vim.split(package.path, ';') },
            diagnostics = {
                -- Don't analyze whole workspace, as it consumes too much CPU and RAM
                workspaceDelay = -1,
            },
            workspace = {
                -- Don't analyze code from submodules
                ignoreSubmodules = true,
                -- Add Neovim's methods for easier code writing
                library = { vim.env.VIMRUNTIME },
            },
            telemetry = { enable = false },
        },
    },
}
