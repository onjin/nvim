local plugins_dir = vim.fn.stdpath "config" .. "/plugins"
return {
  -- { dir = plugins_dir .. "/casify.nvim", config=function()
  -- vim.keymap.set(
  --   "n",
  --   "<space>ct",
  --   ":lua require('casify').toggle_case()<CR>",
  --   { desc = "Toggle snake, camel, pascal, kebab cases", noremap = true, silent = true }
  -- )
  -- vim.keymap.set(
  --   "n",
  --   "<space>cs",
  --   ":lua require('casify').convert_case('snake')<CR>",
  --   { desc = "Convert to snake case", noremap = true, silent = true }
  -- )
  -- vim.keymap.set(
  --   "n",
  --   "<space>cc",
  --   ":lua require('casify').convert_case('camel')<CR>",
  --   { desc = "Convert to camel case", noremap = true, silent = true }
  -- )
  -- vim.keymap.set(
  --   "n",
  --   "<space>cp",
  --   ":lua require('casify').convert_case('pascal')<CR>",
  --   { desc = "Convert to pascal case", noremap = true, silent = true }
  -- )
  -- vim.keymap.set(
  --   "n",
  --   "<space>ck",
  --   ":lua require('casify').convert_case('kebab')<CR>",
  --   { desc = "Convert to kebab case", noremap = true, silent = true }
  -- )
  -- end},
  { dir = plugins_dir .. "/codeblocks.nvim" },
  { dir = plugins_dir .. "/lastplace.nvim" },
  { dir = plugins_dir .. "/present.nvim" },
}
