local _deprecate = vim.deprecate

vim.deprecate = function(name, alternative, version, plugin, backtrace)
  -- hide deprecation info about migration to vim.lsp.config
  if plugin ~= "nvim-lspconfig" then
    _deprecate(name, alternative, version, plugin, backtrace)
  end
end -- hide nvim-lspconfig alert

require "config.options"
require "config.commands"
require "config.keymaps"

-- set/override globals (vim.g) variables from ini file
require("nvimrc").setup { debug = false }

--- initialize plugin manager
require "config.lazy"
