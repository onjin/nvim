-- luacheck: globals vim

local function config()
    local mason = require("mason")
    local lspconfig = require("lspconfig")
    local mason_lspconfig = require("mason-lspconfig")
    local local_config = require("config")

    local mason_options = {}
    mason.setup(mason_options)

    local mason_lspconfig_options = {
        ensure_installed = local_config.lsp_initial_servers,
    }
    mason_lspconfig.setup(mason_lspconfig_options)

    local function on_attach(client, bufnr)
        if client.name == "pyright" then
            local util = require("lspconfig/util")
            local path = util.path

            -- From: https://github.com/IceS2/dotfiles/blob/master/nvim/lua/plugins_cfg/mason_ls_and_dap.lua
            local function get_python_path(workspace)
                -- Use activated virtualenv.
                if vim.env.VIRTUAL_ENV then
                    return path.join(vim.env.VIRTUAL_ENV, "bin", "python")
                end

                -- Find and use virtualenv in workspace directory.
                for _, pattern in ipairs({ "*", ".*" }) do
                    local match = vim.fn.glob(path.join(workspace, pattern, ".python-local"))
                    if match ~= "" then
                        return path.join(vim.env.PYENV_ROOT, "versions", path.dirname(match), "bin", "python")
                    end
                end

                -- Fallback to system Python.
                return exepath("python3") or exepath("python") or "python"
            end

            local function get_venv(workspace)
                for _, pattern in ipairs({ "*", ".*" }) do
                    local match = vim.fn.glob(path.join(workspace, pattern, ".python-local"))
                    if match ~= "" then
                        return match
                    end
                end
            end
            client.config.settings.python.pythonPath = get_python_path(client.config.root_dir)
            client.config.settings.venvPath = path.join(vim.env.PYENV_ROOT, "versions")
            client.config.settings.venv = get_venv(client.config.root_dir)
        end
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

    local handlers_config = {
        -- The first entry (without a key) will be the default handler
        -- and will be called for each installed server that doesn't have
        -- a dedicated handler.
        function(server_name) -- default handler (optional)
            require("lspconfig")[server_name].setup({
                on_attach = on_attach,
                capabilities = capabilities,
            })
        end,
        ["pyright"] = function()
            lspconfig.pyright.setup({
                on_attach = on_attach,
                capabilities = capabilities,
                settings = {
                    python = {
                        analysis = {
                            indexing = true,
                            typeCheckingMode = "strict",
                            diagnosticMode = "openFilesOnly",
                            autoImportCompletions = true,
                            autoSearchPaths = true,
                            inlayHints = {
                                variableTypes = true,
                                functionReturnTypes = true,
                            },
                            useLibraryCodeForTypes = true,
                            diagnosticSeverityOverrides = {
                                reportUnusedImport = "error",
                                reportUnusedClass = "error",
                                reportUnusedFunction = "error",
                                reportUnusedVariable = "error",
                                reportDuplicateImport = "error",
                                reportMissingTypeArgument = "error",
                                reportMissingImports = "error",
                                reportOptionalMemberAccess = "error",
                                reportOptionalSubscript = "error",
                                reportGeneralTypeIssues = "none",
                                reportPrivateImportUsage = "none",
                            },
                        },
                    },
                },
            })
        end,
        ["yamlls"] = function()
            lspconfig.yamlls.setup({
                on_attach = on_attach,
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
        ["jdtls"] = function()
            local opts = {
                cmd = {},
                settings = {
                    java = {
                        signatureHelp = { enabled = true },
                        completion = {
                            favoriteStaticMembers = {},
                            filteredTypes = {
                                -- "com.sun.*",
                                -- "io.micrometer.shaded.*",
                                -- "java.awt.*",
                                -- "jdk.*",
                                -- "sun.*",
                            },
                        },
                        sources = {
                            organizeImports = {
                                starThreshold = 9999,
                                staticStarThreshold = 9999,
                            },
                        },
                        codeGeneration = {
                            toString = {
                                template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
                            },
                            useBlocks = true,
                        },
                        configuration = {
                            runtimes = {
                                {
                                    name = "JavaSE-17",
                                    path = "/usr/lib/jvm/java-17-openjdk/",
                                },
                                {
                                    name = "JavaSE-20",
                                    path = "/usr/lib/jvm/java-20-openjdk/",
                                },
                            },
                        },
                    },
                },
            }

            local pkg_status, jdtls = pcall(require, "jdtls")
            if not pkg_status then
                vim.notify("unable to load nvim-jdtls", "error")
                return {}
            end

            -- local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
            local jdtls_bin = vim.fn.stdpath("data") .. "/mason/bin/jdtls"

            local root_markers = { ".git", ".gradle", "gradlew" }
            local root_dir = jdtls.setup.find_root(root_markers)
            local home = os.getenv("HOME")
            local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
            local workspace_dir = home .. "/.cache/jdtls/workspace/" .. project_name

            opts.root_dir = function()
                return jdtls.setup.find_root(root_markers) or vim.fn.getcwd()
            end

            opts.cmd = {
                jdtls_bin,
                "-data",
                workspace_dir,
            }

            local on_attach = function(client, bufnr)
                jdtls.setup.add_commands() -- important to ensure you can update configs when build is updated
                -- if you setup DAP according to https://github.com/mfussenegger/nvim-jdtls#nvim-dap-configuration you can uncomment below
                -- jdtls.setup_dap({ hotcodereplace = "auto" })
                -- jdtls.dap.setup_dap_main_class_configs()

                -- you may want to also run your generic on_attach() function used by your LSP config
            end

            opts.on_attach = on_attach
            opts.capabilities = vim.lsp.protocol.make_client_capabilities()
            lspconfig.jdtls.setup(opts)
        end,
        ["clangd"] = function()
            lspconfig.clangd.setup({
                on_attach = on_attach,
                cmd = {
                    "clangd",
                    "--offset-encoding=utf-16",
                },
            })
        end,
        ["terraformls"] = function()
            lspconfig.terraformls.setup({
                on_attach = on_attach,
            })
        end,
    }
    if local_config.lsp_efm_config_enabled then
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

        handlers_config["efm"] = function()
            lspconfig.efm.setup({
                capabilities = capabilities,
                on_attach = on_attach,
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
        end
    end
    mason_lspconfig.setup_handlers(handlers_config)
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
        outline = {
            win_width = 30,
            layout = "float",
        },
    }
    local lspsaga = require("lspsaga")
    lspsaga.setup(options_saga)
end

vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
vim.api.nvim_create_autocmd("LspAttach", {
    group = "LspAttach_inlayhints",
    callback = function(args)
        if not (args.data and args.data.client_id) then
            return
        end

        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        require("lsp-inlayhints").on_attach(client, bufnr)
    end,
})

return {
    {
        "nvim-java/nvim-java",
        dependencies = {
            "nvim-java/lua-async-await",
            "nvim-java/nvim-java-core",
            "nvim-java/nvim-java-test",
            "nvim-java/nvim-java-dap",
            "MunifTanjim/nui.nvim",
            "neovim/nvim-lspconfig",
            "mfussenegger/nvim-dap",
            {
                "williamboman/mason.nvim",
                opts = {
                    registries = {
                        "github:nvim-java/mason-registry",
                        "github:mason-org/mason-registry",
                    },
                },
            },
        },
    },
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

            -- Additional lua configuration, makes nvim stuff amazing!
            "folke/neodev.nvim",
        },
        -- your lsp config or other stuff
    },
    { "lvimuser/lsp-inlayhints.nvim" },
    { "haringsrob/nvim_context_vt" },
    { "mfussenegger/nvim-jdtls" },
    {
        "folke/neodev.nvim",
        config = function()
            -- Setup neovim lua configuration
            require("neodev").setup()
        end,
    },
}
