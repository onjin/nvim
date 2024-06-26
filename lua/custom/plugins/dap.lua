return {
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      require("dapui").setup()
      vim.keymap.set("n", "<leader>do", function()
        require("dapui").open()
      end, { desc = "[D]AP UI E[X]it" })
      vim.keymap.set("n", "<leader>dx", function()
        require("dapui").close()
      end, { desc = "[D]AP UI Open" })
    end,
  },
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    config = function()
      require("dap-python").setup()
      vim.keymap.set("n", "<leader>dtm", function()
        require("dap-python").test_method()
      end, { desc = "[D]AP UI [T]est [M]ethod" })
      vim.keymap.set("n", "<leader>dtc", function()
        require("dap-python").test_class()
      end, { desc = "[D]AP UI [T]est [C]lass" })
    end,
  },
}
