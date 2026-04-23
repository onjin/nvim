-- Compatibility filetype registrations for lspconfig defaults on older Neovim
-- filetype tables. Without these, vim.lsp.config warns about unknown filetypes.
vim.filetype.add {
  filename = {
    ["go.work"] = "gowork",
  },
  pattern = {
    [".*/[Dd]ocker%-compose%.ya?ml"] = "yaml.docker-compose",
    [".*/compose%.ya?ml"] = "yaml.docker-compose",
    [".*%.gotmpl"] = "gotmpl",
    [".*%.go%.tmpl"] = "gotmpl",
  },
}

local pack = require "plugins.pack"

pack.add {
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/folke/lazydev.nvim" },
  { src = "https://github.com/mfussenegger/nvim-jdtls" },
  { src = "https://github.com/ray-x/lsp_signature.nvim" },
}

require("lazydev").setup()

local function jdtls_formatter_url(bufnr, client)
  local root = client.config.root_dir
  if not root then
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    root = vim.fs.root(bufname, { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle", "build.gradle.kts" })
  end
  if not root then
    return nil
  end

  local formatter = vim.fs.joinpath(root, "eclipse.formatter.xml")
  if vim.fn.filereadable(formatter) == 1 then
    return vim.uri_from_fname(formatter)
  end
end

---@type table<string, vim.lsp.Config|true>
local servers = {
  jsonls = {
    cmd = { "vscode-json-language-server", "--stdio" },
    filetypes = { "json", "jsonc" },
  },
  lua_ls = {
    filetypes = { "lua" },
  },
  ty = {
    cmd = { "uvx", "ty", "server" },
    filetypes = { "python" },
    settings = {
      ty = {
        diagnosticMode = "workspace",
      },
    },
  }, -- Python
  ruff = {
    cmd = { "uvx", "ruff", "server" },
    filetypes = { "python" },
  },
  bashls = true,
  rust_analyzer = true,
  taplo = true, -- TOML toolkit
  lemminx = true, -- XML
  gopls = true,
  docker_language_server = true,
  nixd = true,
  terraform_lsp = true,
}

for name, spec in pairs(servers) do
  vim.lsp.config(name, spec == true and {} or spec)
  vim.lsp.enable(name)
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    vim.o.signcolumn = "yes:1"
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    local bufnr = args.buf
    local filetype = vim.bo[bufnr].filetype

    -- Let injected Tree-sitter languages like JSON win inside Python strings.
    if filetype == "python" then
      client.server_capabilities.semanticTokensProvider = nil
    end

    if client:supports_method "textDocument/completion" then
      vim.o.complete = "o,.,w,b,u"
      vim.o.completeopt = "menu,menuone,popup,noinsert"
      vim.lsp.completion.enable(true, client.id, bufnr)
    end

    if client:supports_method "textDocument/inlayHint" then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end

    if client.name == "jdtls" then
      local formatter_url = jdtls_formatter_url(bufnr, client)
      if formatter_url then
        client.settings = vim.tbl_deep_extend("force", client.settings or {}, {
          java = {
            format = {
              settings = {
                url = formatter_url,
              },
            },
          },
        })
        client:notify("workspace/didChangeConfiguration", { settings = client.settings })
      end
    end

    vim.keymap.set("n", "grd", vim.lsp.buf.definition, {
      buffer = bufnr,
      desc = "Go to definition",
    })

    vim.keymap.set({ "i" }, "<C-k>", function()
      require("lsp_signature").toggle_float_win()
    end, {
      buffer = bufnr,
      desc = "Signature help",
    })
  end,
})
