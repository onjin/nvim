require("neotest").setup({
  adapters = {
    require("neotest-python")({
      dap = { justMyCode = false },
      args = {"--log-level", "DEBUG"},
      -- Runner to use. Will use pytest if available by default.
      -- Can be a function to return dynamic value.
      runner = "pytest",
    }),
    require("neotest-plenary")
  }
})
