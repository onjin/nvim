require 'config.options'

-- load plugins specification & engine
local spec = require("plugins.spec")
local engine = require("plugins.engine")

engine.execute("mini-deps", spec) -- mini-deps, lazy, builtin (experimental)
