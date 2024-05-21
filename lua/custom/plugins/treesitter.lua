return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "romgrk/nvim-treesitter-context",
      --"nvim-treesitter/nvim-treesitter-textobjects",
    },
    build = ":TSUpdate",
    branch = "main",
    lazy = false,
    config = function()
      require("custom.treesitter").setup()
    end,
  },
}
