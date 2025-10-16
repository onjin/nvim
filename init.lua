-- load options first
require 'config.options'

-- then load plugins specification & engine
local spec = require("plugins.spec")
local engine = require("plugins.engine")

engine.execute(spec) -- defaults to lazy; pass "mini-deps" for MiniDeps sync

-- load other static config
require 'config.terminal'
