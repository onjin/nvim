local function setup_dapui()
  local dapui = require "dapui"
  local dap = require "dap"

  dapui.setup()
  vim.keymap.set("n", "<leader>do", function()
    require("dapui").open()
  end, { desc = "[D]AP UI E[X]it" })
  vim.keymap.set("n", "<leader>dx", function()
    require("dapui").close()
  end, { desc = "[D]AP UI Open" })

  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end

  vim.keymap.set("n", "<F1>", ":lua require'dap'.repl.open()<CR>")
  vim.keymap.set("n", "<F11>", ":lua require'dap'.continue()<CR>")
  vim.keymap.set("n", "<F12>", "lua require'dap'.terminate()<CR>")
  vim.keymap.set("n", "<leader>b", ":lua require'dap'.toggle_breakpoint()<CR>")
  vim.keymap.set("n", "<leader>B", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
  vim.keymap.set(
    "n",
    "<leader>lp",
    ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>"
  )
end

local function setup_dap_python()
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
end
return {
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = setup_dapui,
  },
  {
    "mfussenegger/nvim-dap-python",
    dependencies = { "mfussenegger/nvim-dap" },
    ft = "python",
    config = setup_dap_python,
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
