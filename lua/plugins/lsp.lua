-- luacheck: globals vim
local function config()
    local mason = require("mason")
    local lspconfig = require("lspconfig")
    local mason_lspconfig = require("mason-lspconfig")

    local M = {}

    local mason_options = {}
    mason.setup(mason_options)

    M.on_attach = function(client, bufnr) end

    local capabilities = vim.lsp.protocol.make_client_capabilities()

    capabilities.textDocument.completion.completionItem = {
        documentationFormat = { "markdown", "plaintext" },
        snippetSupport = true,
        preselectSupport = true,
        insertReplaceSupport = true,
        labelDetailsSupport = true,
        deprecatedSupport = true,
        commitCharactersSupport = true,
        tagSupport = { valueSet = { 1 } },
        resolveSupport = {
            properties = {
                "documentation",
                "detail",
                "additionalTextEdits",
            },
        },
    }

    -- autocnofigure all servers

    -- 2. (optional) Override the default configuration to be applied to all servers.
    lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
        on_attach = M.on_attach,
        capabilities = capabilities,
    })

    lspconfig.lua_ls.setup({
        on_attach = M.on_attach,
        capabilities = capabilities,
        settings = {
            Lua = {
                diagnostics = {
                    globals = { "vim" },
                },
                workspace = {
                    library = {
                        [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                        [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                    },
                    maxPreload = 100000,
                    preloadFileSize = 10000,
                },
            },
        },
    })

    lspconfig.pyright.setup({
        on_attach = M.on_attach,
        capabilities = capabilities,
    })

    -- thanks to https://github.com/lukas-reineke/dotfiles/blob/6a407f32a73fe8233688e6abfcf366fe5c5c7125/vim/lua/lsp/init.lua
    local bandit = require("efm/bandit")
    local black = require("efm/black")
    local eslint = require("efm/eslint")
    -- local flake8 = require("efm/flake8")
    local goimports = require("efm/goimports")
    local go_vet = require("efm/go_vet")
    local isort = require("efm/isort")
    local ruff = require("efm/ruff")
    local luacheck = require("efm/luacheck")
    local misspell = require("efm/misspell")
    -- local mypy = require("efm/mypy")
    local opa = require("efm/opa")
    local prettier = require("efm/prettier")
    local shellcheck = require("efm/shellcheck")
    local shfmt = require("efm/shfmt")
    local staticcheck = require("efm/staticcheck")
    local stylua = require("efm/stylua")
    local terraform = require("efm/terraform")
    local vint = require("efm/vint")

    local mason_lspconfig_options = {
        ensure_installed = { "lua_ls", "efm", "pyright" },
    }
    mason_lspconfig.setup(mason_lspconfig_options)
    mason_lspconfig.setup_handlers({
        -- The first entry (without a key) will be the default handler
        -- and will be called for each installed server that doesn't have
        -- a dedicated handler.
        function(server_name) -- default handler (optional)
            require("lspconfig")[server_name].setup({})
        end,
        -- Next, you can provide a dedicated handler for specific servers.
        -- For example, a handler override for the `rust_analyzer`:
        -- ["rust_analyzer"] = function ()
        --     require("rust-tools").setup {}
        -- end
        ["efm"] = function()
            lspconfig.efm.setup({
                capabilities = capabilities,
                on_attach = M.on_attach,
                init_options = { documentFormatting = true },
                root_dir = vim.loop.cwd,
                settings = {
                    rootMarkers = { ".git/" },
                    lintDebounce = 100,
                    -- logLevel = 5,
                    languages = {
                        ["="] = { misspell },
                        vim = { vint },
                        lua = { stylua, luacheck },
                        go = { staticcheck, goimports, go_vet },
                        python = { ruff, black },
                        typescript = { prettier, eslint },
                        javascript = { prettier, eslint },
                        typescriptreact = { prettier, eslint },
                        javascriptreact = { prettier, eslint },
                        yaml = { prettier },
                        json = { prettier },
                        html = { prettier },
                        scss = { prettier },
                        css = { prettier },
                        markdown = { prettier },
                        sh = { shellcheck, shfmt },
                        terraform = { terraform },
                        rego = { opa },
                    },
                },
            })
        end,
    })

    require("lspconfig").emmet_ls.setup({
        -- on_attach = on_attach,
        capabilities = capabilities,
        filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "htmldjango" },
        init_options = {
            html = {
                options = {
                    -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
                    ["bem.enabled"] = true,
                },
            },
        },
    })

    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        -- whether to show or not inline diagnostics errors - still available as float
        virtual_text = true,
    })

    local lsp_signature = require("lsp_signature")
    local options_saga = {
        bind = true, -- This is mandatory, otherwise border config won't get registered.
        handler_opts = {
            border = "rounded",
        },
        hint_prefix = "💡",
    }
    -- lsp_signature.setup(options_saga)

    local lspsaga = require("lspsaga")

    local options = {
        symbol_in_winbar = {
            in_custom = false,
            enable = true,
            click_support = function(node, clicks, button, modifiers)
                -- To see all avaiable details: vim.pretty_print(node)
                local st = node.range.start
                local en = node.range["end"]
                if button == "l" then
                    if clicks == 2 then
                        -- double left click to do nothing
                        clicks = 2
                    else -- jump to node's starting line+char
                        vim.fn.cursor(st.line + 1, st.character + 1)
                    end
                elseif button == "r" then
                    if modifiers == "s" then
                        print("lspsaga") -- shift right click to print "lspsaga"
                    end -- jump to node's ending line+char
                    vim.fn.cursor(en.line + 1, en.character + 1)
                elseif button == "m" then
                    -- middle click to visual select node
                    vim.fn.cursor(st.line + 1, st.character + 1)
                    vim.cmd("normal v")
                    vim.fn.cursor(en.line + 1, en.character + 1)
                end
            end,
        },
    }
    lspsaga.setup(options)

    return M
end

return {
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        lazy = false,
        cmd = { "Mason", "LspInstall" },
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "neovim/nvim-lspconfig",
            "ray-x/lsp_signature.nvim",
            "glepnir/lspsaga.nvim",
            "liuchengxu/vista.vim",
        },
        config = config,
    },
}
