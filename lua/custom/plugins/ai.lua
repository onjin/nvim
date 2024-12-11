return {
   { "jcdickinson/codeium.nvim" }, -- set vim.g.ai_enabled to true to activate
   {
      "David-Kunz/gen.nvim",
      opts = {
         model = "qwen", -- The default model to use.
         debug = false,

      },
      config = function()
         require('gen').setup {
         }
         vim.keymap.set({ 'n', 'v' }, '<leader>a', ':Gen<CR>')
      end
   }, -- local ollama
}
