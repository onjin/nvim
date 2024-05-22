return {
  {
    "tris203/precognition.nvim",
    event = "VeryLazy",
    config = function()
      require("precognition").show()
      vim.keymap.set("n", "<leader>tp", function()
        require("precognition").toggle()
      end, { desc = "[T]oggle [P]recognition movement hints" })
    end,
  }, -- moving hints as virtual text
  {
    "m4xshen/hardtime.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    config = function()
      require("hardtime").setup()
      vim.keymap.set("n", "<leader>tH", function()
        require("hardtime").toggle()
      end, { desc = "[T]oggle [H]ardtime hints" })
    end,
  },
}
