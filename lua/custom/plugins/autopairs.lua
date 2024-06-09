-- Auto-completion of bracket/paren/quote pairs
return {
  --   {
  --   -- https://github.com/windwp/nvim-autopairs
  --   "windwp/nvim-autopairs",
  --   event = "InsertEnter",
  --   opts = {
  --     check_ts = true, -- enable treesitter
  --     ts_config = {
  --       lua = { "string" }, -- don't add pairs in lua string treesitter nodes
  --       javascript = { "template_string" }, -- don't add pairs in javascript template_string
  --     },
  --   },
  -- },
  {
    "altermo/ultimate-autopair.nvim",
    event = { "InsertEnter", "CmdlineEnter" },
    branch = "v0.6", --recommended as each new version will have breaking changes
    opts = {
      --Config goes here
    },
  },
}
