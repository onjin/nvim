local function setup_lsp()
  -- Setup the LSP using mason autoconfig,
  -- without auto installing configured servers
  -- and do not require specific configuration to auto setup servers
  local use_ty = false -- so far just testing, but `ty` fails on many Generic/TypeVarTuples etc

  local lspconfig = require "lspconfig"

  require("mason-lspconfig").setup {
    automatic_installation = false,
    ensure_installed = vim.g.lsp_servers_ensure_installed,
    handlers = {
      -- The first entry (without a key) will be the default handler
      -- and will be called for each installed server that doesn't have
      -- a dedicated handler.
      function(server_name) -- default handler (optional)
        if lspconfig[server_name] ~= nil and type(lspconfig[server_name].setup) == "function" then
          lspconfig[server_name].setup {}
        end
      end,
      -- Next, you can provide a dedicated handler for specific servers.
      ["basedpyright"] = function()
        lspconfig.basedpyright.setup {
          basedpyright = {
            disableOrganizeImports = true, -- Using Ruff LSP
          },
          python = {
            analysis = {
              autoSearchPaths = true,
              exclude = {
                "**/.cache",
                "**/.mypy_cache",
                "**/.pytest_cache",
                "**/.ruff_cache",
                "**/.venv",
                "**/__pycache__",
                "**/dist",
                "**/node_modules",
              },
              indexing = true,
              typeCheckingMode = "recommended",
              memory = {
                keepLibraryAst = true,
                keepLibraryLocalVariables = false,
              },
              diagnosticMode = "workspace",
              useLibraryCodeForTypes = true,
              logLevel = "Error",
              ignore = { "*" }, -- Using Ruff LSP
              inlayHints = {
                callArgumentNames = true,
                variableTypes = true,
                functionReturnTypes = true,
                genericTypes = true,
              },
              useTypingExtensions = true,
            },
          },
        }
      end,
      ["ruff"] = function()
        lspconfig.ruff.setup {
          on_attach = function(client)
            if client.name == "ruff" then
              -- Disable hover in favor of Pyright
              client.server_capabilities.hoverProvider = false
            end
          end,
        }
      end,
      ["gopls"] = function()
        lspconfig.gopls.setup {
          gopls = {
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
          },
        }
      end,
      ["jsonls"] = function()
        lspconfig.jsonls.setup {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        }
      end,
      ["yamlls"] = function()
        lspconfig.yamlls.setup {
          yaml = {
            schemaStore = {
              enable = false,
              url = "",
            },
            schemas = require("schemastore").yaml.schemas(),
          },
        }
      end,
      -- ["jdtls"] = function()
      --   lspconfig.jdtls.setup {
      --     root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw", "pom.xml" }, { upward = true })[1]),
      --   }
      -- end,
    },
  }
  vim.lsp.config("basedpyright", {
    on_attach = function(client)
      -- disable diagnostics in favour of `ty`
      if use_ty then
        client.handlers["textDocument/publishDiagnostics"] = function() end
      end
    end,
  })

  if use_ty then
    vim.lsp.config("ty", {
      cmd = { "uvx", "ty", "server" },
      filetypes = { "python" },
      root_dir = vim.fs.dirname(vim.fs.find({ "ty.toml", ".git", "pyproject.toml" }, { upward = true })[1])
          or vim.fn.getcwd(),
      capabilities = {
        textDocument = {
          publishDiagnostics = {},
        },
      },
      on_attach = function(client, bufnr)
        -- Disable everything else
        client.server_capabilities.hoverProvider = false
        client.server_capabilities.definitionProvider = false
        client.server_capabilities.referencesProvider = false
        client.server_capabilities.completionProvider = false
        client.server_capabilities.renameProvider = false
        client.server_capabilities.documentSymbolProvider = false
      end,
    })
    vim.lsp.enable "ty"
  end

  -- disable this so far, not sure whether i need this
  -- local capabilities = nil
  -- if pcall(require, "cmp_nvim_lsp") then
  --   capabilities = require("cmp_nvim_lsp").default_capabilities()
  -- end

  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local map = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { buffer = args.buf, desc = desc })
      end
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"

      -- When you move your cursor, the highlights will be cleared (the second autocommand).
      if client and client.server_capabilities.documentHighlightProvider then
        local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          buffer = args.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
          buffer = args.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.clear_references,
        })

        vim.api.nvim_create_autocmd("LspDetach", {
          group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
          callback = function(event2)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds { group = "kickstart-lsp-highlight", buffer = event2.buf }
          end,
        })
      end

      -- The following autocommand is used to enable inlay hints in your
      -- code, if the language server you are using supports them
      --
      -- This may be unwanted, since they displace some of your code
      if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
        map("<leader>th", function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
        end, "[T]oggle Inlay [H]ints")
      end

      local filetype = vim.bo[bufnr].filetype
      if client and vim.g.lsp_disable_semantic_tokens[filetype] then
        client.server_capabilities.semanticTokensProvider = nil
      end
    end,
  })

  -- Autoformatting Setup
  require("conform").setup {
    formatters_by_ft = {
      lua = { "stylua" },
      nix = { "nixfmt" },
      python = { "black", "ruff" },
      rust = { "rustfmt", lsp_format = "fallback" },
      typescript = { "prettier" },
      typescriptreact = { "prettier" },
      java = { "checkstyle" },
      javascript = { "prettier" },
      javascriptreact = { "prettier" },
      html = { "prettier" },
      htmldjango = { "djlint" },
      css = { "prettier" },
      scss = { "prettier" },
      markdown = { "prettier" },
      yaml = { "prettier" },
      graphql = { "prettier" },
      vue = { "prettier" },
      angular = { "prettier" },
      less = { "prettier" },
      flow = { "prettier" },
      sh = { "beautysh" },
      bash = { "beautysh" },
      zsh = { "beautysh" },
      http = { "kulala-fmt" },
    },
  }

  if vim.g.autoformat_on_save_enabled == 1 or vim.g.autoformat_on_save_enabled == true then
    vim.api.nvim_create_autocmd("BufWritePre", {
      callback = function(args)
        require("conform").format {
          bufnr = args.buf,
          lsp_fallback = true,
          quiet = true,
        }
      end,
    })
  end
  vim.keymap.set("n", "<leader>lf", function()
    require("conform").format {
      lsp_fallback = true,
      quiet = true,
    }
  end, { desc = "LSP: [C]ode [F]ormat" })
  -- Map the selector to <leader>t
  vim.keymap.set(
    "n",
    "<leader>tn",
    ToggleDiagnosticsSelector,
    { noremap = true, silent = true, desc = "Select and toggle diagnostics by namespace" }
  )
end

local function setup_navbuddy()
  require("nvim-navbuddy").setup { lsp = { auto_attach = true } }
  vim.keymap.set("n", "<leader>ln", function()
    require("nvim-navbuddy").open()
  end, { desc = "LSP: [G]oto [N]avbuddy" })
end

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "SmiteshP/nvim-navbuddy",
        config = setup_navbuddy,
      },
      {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
      { "mason-org/mason.nvim",           opts = {} },
      { "mason-org/mason-lspconfig.nvim", opts = {} },

      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "haringsrob/nvim_context_vt",

      { "j-hui/fidget.nvim", opts = {} },

      -- Autoformatting
      "stevearc/conform.nvim",

      -- Schema information
      "b0o/SchemaStore.nvim",
      {
        "nvim-java/nvim-java",
        config = false,
        dependencies = {
          {
            {
              "mason-org/mason-lspconfig.nvim",
              opts = {
                setup = {
                  jdtls = function()
                    -- Your nvim-java configuration goes here
                    require("java").setup({})
                  end,
                },
              },
            },
          },
        },
      },
    },
    config = setup_lsp,
  },
  {
    "SmiteshP/nvim-navic",
  },
  {
    "nvim-tree/nvim-web-devicons", -- optional dependency
  },
  {
    "utilyre/barbecue.nvim",
    enabled = false,
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    opts = {},
  },
  {
    "hedyhli/outline.nvim",
    lazy = true,
    cmd = { "Outline", "OutlineOpen" },
    keys = { -- Example mapping to toggle outline
      { "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
    },
    opts = {
      -- Your setup opts here
    },
  },
  {
    "saecki/crates.nvim",
    tag = "stable",
    config = function()
      require("crates").setup {
        lsp = {
          enabled = true,
          on_attach = function(client, bufnr)
            -- the same on_attach function as for your other lsp's
          end,
          actions = true,
          completion = true,
          hover = true,
        },
      }
    end,
  },
}
