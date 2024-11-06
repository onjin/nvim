return {
  { "mfussenegger/nvim-dap" },
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
    dependencies = { "mfussenegger/nvim-dap" },
    ft = "python",
    config = function()
      require("dap-python").setup(vim.g.python_host_prog)
      vim.keymap.set("n", "<leader>dtm", function()
        require("dap-python").test_method()
      end, { desc = "[D]AP UI [T]est [M]ethod" })
      vim.keymap.set("n", "<leader>dtc", function()
        require("dap-python").test_class()
      end, { desc = "[D]AP UI [T]est [C]lass" })
      require("dap-python").test_runner = "pytest"

      table.insert(require("dap").configurations.python, {
        type = "python",
        request = "attach",
        name = "Container Python Attach",
        port = function()
          return vim.fn.input("Port > ", 3000)
        end,
        host = function()
          return vim.fn.input("Host > ", "127.0.0.1")
        end,
        mode = "remote",
        cwd = vim.fn.getcwd(),
        pathMappings = {
          {
            localRoot = function()
              return vim.fn.input("Local code folder > ", vim.fn.getcwd(), "file")
            end,
            remoteRoot = function()
              return vim.fn.input("Container code folder > ", "/opt/application", "file")
            end,
          },
        },
      })
    end,
  },
  {
    "leoluz/nvim-dap-go",
    config = function()
      require("dap-go").setup()
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    config = function()
      require("nvim-dap-virtual-text").setup()
    end,
  },
}
