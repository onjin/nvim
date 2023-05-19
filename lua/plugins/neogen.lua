return {
  {
    "danymat/neogen",
    lazy = true,
    cmd = { "Neogen" },
    config = function()
      require("neogen").setup({
        enabled = true,
        languages = {
          lua = {
            template = {
              annotation_convention = "emmylua",
            },
          },
          python = {
            template = {
              annotation_convention = "google_docstrings",
            },
          },
        },
      })
    end,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
}
