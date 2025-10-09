local Lsp = require "utils.lsp"

return {
  cmd = { "lua-language-server" },
  on_attach = Lsp.on_attach,
  filetypes = { "lua" },
  root_markers = { ".luarc.json", ".luarc.jsonc" },
}
