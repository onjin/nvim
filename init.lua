require "config.options"
require "config.autocommands"
require "config.keymaps"
require "config.treesitter"

-- Enable LSP servers for Neovim 0.11+
vim.lsp.enable(vim.g.lsp_enabled_servers)

-- Reload Neovim config
function ReloadConfig()
  -- Clear keymaps
  for _, mode in ipairs { "n", "v", "x", "s", "o", "i", "l", "c", "t" } do
    for lhs, _ in pairs(vim.api.nvim_get_keymap(mode)) do
      pcall(vim.api.nvim_del_keymap, mode, lhs)
    end
  end

  -- Optionally: clear autocmds, plugins, etc.
  -- Reset package.loaded modules (useful if you split config into modules)
  for name, _ in pairs(package.loaded) do
    if name:match "^config" then
      package.loaded[name] = nil
    end
  end

  -- Reload config
  dofile(vim.env.MYVIMRC)
  print "✅ Config reloaded!"
end

vim.keymap.set("n", "<leader>rr", ReloadConfig)
