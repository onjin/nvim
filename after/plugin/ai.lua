if vim.g.ai_enabled then
   require("codeium").setup {
      enable_cmp_source = true,
      virtual_text = {
         enabled = false,
      }
   }
end

require('gen').setup {
   model = "qwen", -- The default model to use.
   debug = false,
}
vim.keymap.set({ 'n', 'v' }, '<leader>a', ':Gen<CR>')
