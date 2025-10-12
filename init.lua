-- load options first
require 'config.options'

-- then load plugins specification & engine
local spec = require("plugins.spec")
local engine = require("plugins.engine")

engine.execute("mini-deps", spec) -- mini-deps, lazy, builtin (experimental)

-- load other static config
require 'config.terminal'
