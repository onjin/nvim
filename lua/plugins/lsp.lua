-- Function to toggle diagnostics for a specific namespace
local function toggle_diagnostics_for_namespace(namespace_id)
  local namespace = vim.diagnostic.get_namespace(namespace_id)
  if namespace == nil then
    return
  end

  if namespace.disabled then
    vim.diagnostic.enable(true, { ns_id = namespace_id })
    vim.notify(string.format("Diagnostics enabled for namespace ID: %d", namespace_id))
  else
    vim.diagnostic.enable(false, { ns_id = namespace_id })
    vim.notify(string.format("Diagnostics disabled for namespace ID: %d", namespace_id))
  end
end

-- Function to create a Telescope picker for toggling namespaces
function ToggleDiagnosticsSelector()
  local namespaces = vim.diagnostic.get_namespaces()
  local results = {}

  for namespace_id, namespace_info in pairs(namespaces) do
    local namespace_name = namespace_info.name
    local diagnostic_status = namespace_info.disabled == true and "Off" or "On"
    table.insert(results, {
      id = namespace_id,
      name = namespace_name,
      status = diagnostic_status,
      display = string.format("%-4d | %-20s | %s", namespace_id, namespace_name, diagnostic_status),
    })
  end

  require("telescope.pickers")
    .new({}, {
      prompt_title = "Toggle Diagnostics by Namespace",
      finder = require("telescope.finders").new_table {
        results = results,
        entry_maker = function(entry)
          return {
            value = entry.id,
            display = entry.display,
            ordinal = entry.name,
            namespace_id = entry.id,
          }
        end,
      },
      sorter = require("telescope.config").values.generic_sorter {},
      attach_mappings = function(prompt_bufnr, map)
        local actions = require "telescope.actions"
        local action_state = require "telescope.actions.state"

        map("i", "<CR>", function()
          local selection = action_state.get_selected_entry()
          if selection then
            toggle_diagnostics_for_namespace(selection.namespace_id)
          end
          actions.close(prompt_bufnr)
        end)

        map("n", "<CR>", function()
          local selection = action_state.get_selected_entry()
          if selection then
            toggle_diagnostics_for_namespace(selection.namespace_id)
          end
          actions.close(prompt_bufnr)
        end)

        return true
      end,
    })
    :find()
end

local function setup_lsp()
  -- Setup the LSP using mason autoconfig,
  -- without auto installing configured servers
  -- and do not require specific configuration to auto setup servers
  local lspconfig = require "lspconfig"

  require("mason").setup()
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
              logflevel = "Error",
              ignore = { "*" }, -- Using Ruff LSP
              inlayHints = {
                variableTypes = true,
                functionReturnTypes = true,
              },
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
    },
  }

  -- disable this so far, not sure whether i need this
  -- local capabilities = nil
  -- if pcall(require, "cmp_nvim_lsp") then
  --   capabilities = require("cmp_nvim_lsp").default_capabilities()
  -- end

  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"

      local map = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { buffer = args.buf, desc = "LSP: " .. desc })
        -- for LSP related items. It sets the mode, buffer and description for us each time.
      end

      -- Jump to the definition of the word under your cursor.
      --  This is where a variable was first declared, or where a function is defined, etc.
      --  To jump back, press <C-t>.
      map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

      -- Find references for the word under your cursor.
      map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

      -- Jump to the implementation of the word under your cursor.
      --  Useful when your language has ways of declaring types without an actual implementation.
      map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

      -- Jump to the type of the word under your cursor.
      --  Useful when you're not sure what type a variable is and you want to see
      --  the definition of its *type*, not where it was *defined*.
      map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

      -- Fuzzy find all the symbols in your current document.
      --  Symbols are things like variables, functions, types, etc.
      map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

      -- Fuzzy find all the symbols in your current workspace.
      --  Similar to document symbols, except searches over your entire project.
      map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

      -- Rename the variable under your cursor.
      --  Most Language Servers support renaming across files, etc.
      map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

      -- Execute a code action, usually your cursor needs to be on top of an error
      -- or a suggestion from your LSP for this to activate.
      map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

      -- Opens a popup that displays documentation about the word under your cursor
      --  See `:help K` for why this keymap.
      map("K", vim.lsp.buf.hover, "Hover Documentation")

      -- WARN: This is not Goto Definition, this is Goto Declaration.
      --  For example, in C this would take you to the header.
      map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

      -- The following two autocommands are used to highlight references of the
      -- word under your cursor when your cursor rests there for a little while.
      --    See `:help CursorHold` for information about when this is executed
      --
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
      if vim.g.lsp_disable_semantic_tokens[filetype] then
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
      javascript = { "prettier" },
      javascriptreact = { "prettier" },
      html = { "prettier" },
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

  if vim.g.autoformat_on_save_enabled then
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
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "haringsrob/nvim_context_vt",

      { "j-hui/fidget.nvim", opts = {} },

      -- Autoformatting
      "stevearc/conform.nvim",

      -- Schema information
      "b0o/SchemaStore.nvim",
    },
    config = setup_lsp,
  },
  { "mfussenegger/nvim-jdtls" }, -- the exension for built in LSP jdtls
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
}
