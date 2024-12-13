-- core plugins, like movements, splits, indents, autopair, etc
-- setup at: after/plugins/core.lua
return {
   { 'echasnovski/mini.ai',          version = false }, -- Extend and create a/i textobjects
   { 'echasnovski/mini.align',       version = false }, -- Align text interactively
   { 'echasnovski/mini.bracketed',   version = false }, -- Go forward/backward with square brackets
   { 'echasnovski/mini.icons',       version = false }, -- Icon provider
   { 'echasnovski/mini.indentscope', version = false }, -- Visualize and work with indent scope
   { 'echasnovski/mini.pairs',       version = false }, -- Minimal and fast autopairs
   { 'echasnovski/mini.surround',    version = false }, -- Fast and feature-rich surround actions
   { 'echasnovski/mini.tabline',     version = false }, -- Minimal and fast tabline showing listed buffers
   { "editorconfig/editorconfig-vim" },                 -- Support .editorconfig file settings
   { "chaoren/vim-wordmotion" },                        -- More useful word motions for Vim
   { 'echasnovski/mini.hipatterns',  version = false }, -- Highlight patterns in text
}
