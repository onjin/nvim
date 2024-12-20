local function setup_codeium()
  if vim.g.ai_enabled then
    require("codeium").setup {
      enable_cmp_source = true,
      virtual_text = {
        enabled = false,
      },
    }
  end
end
local function setup_gen()
  require("gen").setup {
    model = "qwen", -- The default model to use.
    debug = false,
  }
  vim.keymap.set({ "n", "v" }, "<leader>a", ":Gen<CR>")
end
return {
  { "Exafunction/codeium.nvim", config = setup_codeium }, -- set vim.g.ai_enabled to true to activate
  { "David-Kunz/gen.nvim", config = setup_gen }, -- local ollama
}
