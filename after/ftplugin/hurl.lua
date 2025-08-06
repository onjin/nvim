local keys = {
  -- Run API request
  { "n", "<localleader>A",  "<cmd>HurlRunner<CR>",        "Run All requests" },
  { "n", "<localleader>a",  "<cmd>HurlRunnerAt<CR>",      "Run Api request" },
  { "n", "<localleader>te", "<cmd>HurlRunnerToEntry<CR>", "Run Api request to entry" },
  { "n", "<localleader>tE", "<cmd>HurlRunnerToEnd<CR>",   "Run Api request from current entry to end" },
  { "n", "<localleader>tm", "<cmd>HurlToggleMode<CR>",    "Hurl Toggle Mode" },
  { "n", "<localleader>tv", "<cmd>HurlVerbose<CR>",       "Run Api in verbose mode" },
  { "n", "<localleader>tV", "<cmd>HurlVeryVerbose<CR>",   "Run Api in very verbose mode" },
  -- Run Hurl request in visual mode
  { "v", "<localleader>h",  ":HurlRunner<CR>",            "Hurl Runner" },
}
for i, m in ipairs(keys) do
  vim.keymap.set(m[1], m[2], m[3], { desc = m[4] })
end
