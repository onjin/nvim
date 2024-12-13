require('mini.ai').setup()                      -- Extend and create a/i textobjects
require('mini.align').setup()                   -- Align text interactively
require('mini.bracketed').setup()               -- Go forward/backward with square brackets
require("mini.icons").setup()                   -- Icon provider
require("mini.icons").tweak_lsp_kind("replace") -- prepend lsp icons
require('mini.indentscope').setup()             -- Visualize and work with indent scope
require('mini.pairs').setup()                   -- Minimal and fast autopairs
require('mini.surround').setup()                -- Fast and feature-rich surround actions
require('mini.tabline').setup()                 -- Minimal and fast tabline showing listed buffers
require('lastplace').setup()

local hipatterns = require('mini.hipatterns')
hipatterns.setup({
   highlighters = {
      -- Highlight hex color strings (`#rrggbb`) using that color
      hex_color = hipatterns.gen_highlighter.hex_color(),
   },
})
