lua <<EOF
require("notify").setup({
  -- Minimum level to show
  level = "info",
})
require('telescope').load_extension('notify')
EOF
