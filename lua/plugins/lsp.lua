local pack = require "plugins.pack"

pack.add {
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/folke/lazydev.nvim" },
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
  jdtls = {
    filetypes = { "java" },
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
  },
  ruff = {
    cmd = { "uvx", "ruff", "server" },
    filetypes = { "python" },
  },
  bashls = true,
  rust_analyzer = true,
  taplo = true, -- toml toolkit
}

for name, spec in pairs(servers) do
  vim.lsp.config(name, spec == true and {} or spec)
  vim.lsp.enable(name)
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    vim.o.signcolumn = "yes:1"
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

    if client:supports_method "textDocument/completion" then
      vim.o.complete = "o,.,w,b,u"
      vim.o.completeopt = "menu,menuone,popup,noinsert"
      vim.lsp.completion.enable(true, client.id, args.buf)
    end

    if client:supports_method "textDocument/inlayHint" then
      vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    end

    if client.name == "jdtls" then
      local formatter_url = jdtls_formatter_url(args.buf, client)
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
      buffer = args.buf,
      desc = "Go to definition",
    })
  end,
})
