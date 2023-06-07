return {
  {
    "RutaTang/spectacle.nvim",
    config = function()
      require("spectacle").setup {}
    end,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim'
    }
  }
}
