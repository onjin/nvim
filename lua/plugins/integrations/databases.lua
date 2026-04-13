local pack = require "plugins.pack"

pack.add {
  { src = "https://github.com/joryeugene/dadbod-grip.nvim" },
}
require("dadbod-grip").setup { ai = false }
