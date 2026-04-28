local pack = require "plugins.pack"
pack.add {
  { src = "https://github.com/martineausimon/nvim-lilypond-suite" },
  { src = "https://github.com/MunifTanjim/nui.nvim" },
}
require("nvls").setup {
  lilypond = {
    mappings = {
      player = "<leader>lp",
      compile = "<leader>lc",
      open_pdf = "<leader>lv",
    },
  },
  player = {
    options = {
      midi_synh = "timidity",
    },
  },
}
