local map = require('utils').map

require("neotest").setup({
  adapters = {
    require("neotest-python")({
      dap = { justMyCode = false },
      args = {"--log-level", "DEBUG"},
      -- Runner to use. Will use pytest if available by default.
      -- Can be a function to return dynamic value.
      runner = "pytest",
      executable = "docker-compose exec app pytest --ini=config.ini"
    }),
    require("neotest-plenary")
  }
})

map('n', '<leader>tr', ':lua require("neotest").run.run()<cr>')
map('n', '<leader>tl', ':lua require("neotest").run.run_last()<cr>')
map('n', '<leader>tf', ':lua require("neotest").run.run(vim.fn.expand("%"))<cr>')
map('n', '<leader>tu', ':lua require("neotest").run.stop()<cr>')
map('n', '<leader>ta', ':lua require("neotest").run.attach()<cr>')

map('n', '<leader>tw', ':lua require("neotest").summary.toggle()<cr>')
map('n', '<leader>to', ':lua require("neotest").output.open()<cr>')
map('n', '<leader>ts', ':lua require("neotest").output.open({ short = true })<cr>')

map('n', ']i', ':lua require("neotest").jump.next()<cr>', { silent = true })
map('n', '[i', ':lua require("neotest").jump.prev()<cr>', { silent = true })
map('n', ']n', ':lua require("neotest").jump.next({ status = "failed" })<cr>', { silent = true })
map('n', '[n', ':lua require("neotest").jump.prev({ status = "failed" })<cr>', { silent = true })
