---@meta

---@alias PluginStage '"now"' | '"later"'

---@class PluginPin
---@field checkout? string  # git branch or ref to checkout
---@field tag?      string  # optional tag
---@field commit?   string  # optional commit

---@class PluginDep
---@field source string     # "owner/repo"
---@field name?  string     # load name (defaults to repo)

---@class PluginSpec
---@field source   string            # "owner/repo"
---@field name?    string            # explicit module name; defaults to repo
---@field stage?   PluginStage       # when to load (engine maps this)
---@field depends? PluginDep[]       # dependencies (shallow list)
---@field opts?    table             # passed to module.setup(opts)
---@field config?  fun()             # optional post-load config
---@field pin?     PluginPin         # pinning info
---@field event?   string            # hint for lazy.nvim only
---@field notes?   string            # free-form doc string

---@alias PluginSpecList PluginSpec[]
