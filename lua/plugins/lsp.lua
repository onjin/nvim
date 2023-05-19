-- luacheck: globals vim
local function config()
    local mason = require("mason")
    local lspconfig = require("lspconfig")
    local mason_lspconfig = require("mason-lspconfig")

    local M = {}

    local mason_options = {}
    mason.setup(mason_options)

    M.on_attach = function(client, bufnr)
        -- print("attached")
    end

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
     local mypy = require("efm/mypy")
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
        ["lua_ls"] = function()
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
        end,
        ["pyright"] = function()
            lspconfig.pyright.setup({
                on_attach = M.on_attach,
                capabilities = capabilities,
            })
        end,
        ["yamlls"] = function()
            lspconfig.yamlls.setup({
                on_attach = M.on_attach,
                settings = {
                    yaml = {
                        schemaStore = {
                            url = "https://www.schemastore.org/api/json/catalog.json",
                            enable = true,
                        },
                        keyOrdering = false,
                    },
                },
                capabilities = capabilities,
            })
        end,
        ["emmet_ls"] = function()
            lspconfig.emmet_ls.setup({
                -- on_attach = on_attach,
                capabilities = capabilities,
                filetypes = {
                    "html",
                    "typescriptreact",
                    "javascriptreact",
                    "css",
                    "sass",
                    "scss",
                    "less",
                    "htmldjango",
                },
                init_options = {
                    html = {
                        options = {
                            -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
                            ["bem.enabled"] = true,
                        },
                    },
                },
            })
        end,
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

    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        -- whether to show or not inline diagnostics errors - still available as float
        virtual_text = true,
    })

    local options_saga = {
        ui = {},
        lightbulb = {
            enable = true,
            enable_in_insert = false,
            sign = true,
            sign_priority = 40,
            virtual_text = false,
        },
    }
    local lspsaga = require("lspsaga")
    lspsaga.setup(options_saga)

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
            "glepnir/lspsaga.nvim",
            "liuchengxu/vista.vim",
        },
        config = config,
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            {
                "SmiteshP/nvim-navbuddy",
                dependencies = {
                    "SmiteshP/nvim-navic",
                    "MunifTanjim/nui.nvim",
                },
                opts = { lsp = { auto_attach = true } },
            },
        },
        -- your lsp config or other stuff
    },
}
