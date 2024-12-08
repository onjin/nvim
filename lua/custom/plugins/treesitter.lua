return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "romgrk/nvim-treesitter-context",
      --"nvim-treesitter/nvim-treesitter-textobjects",
    },
    build = ":TSUpdate",
    lazy = false,
    config = function()
      require("custom.treesitter").setup()
    end,
  },
}
