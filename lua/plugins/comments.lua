return {
  "danymat/neogen",
  config = function()
    require("neogen").setup {
      enabled = true,
      languages = {
        lua = {
          template = {
            annotation_convention = "emmylua", -- for a full list of annotation_conventions, see supported-languages below,
          },
        },
        python = {
          template = {
            annotation_convention = "google_docstrings",
          },
        },
      },
    }
  end,
  -- Uncomment next line if you want to follow only stable versions
  -- version = "*"
}
