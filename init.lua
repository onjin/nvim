if vim.version.ge(vim.version(), { 0, 12, 0 }) then
  require "plugins.core"
  require "plugins.ui"
  require "plugins.editing"
  require "plugins.generators"
  require "plugins.navigation"
  require "plugins.lsp"
  require "plugins.integrations.discord"
  require "plugins.integrations.databases"
else
  local v = vim.version()
  vim.notify("Skip config, neovim >= 0.12.0 is required. This is " .. v.major .. "." .. v.minor .. "." .. v.patch)
end
