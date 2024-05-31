return {
  "onjin/tailwind-tools.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  opts = {
    document_color = {
      enabled = true,
      kind = "inline",
    },
    conceal = {
      enabled = true,
      min_length = 15,
    },
  }, -- your configuration
}
