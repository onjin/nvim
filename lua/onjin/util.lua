-- luacheck: globals vim
local M = {}

local merge_tb = vim.tbl_deep_extend

M.load_config = function()
  local config = require("core.default_config")
  config.mappings.disabled = nil
  return config
end

M.load_mappings = function(mappings, mapping_opt)
  -- set mapping function with/without whichkey
  local set_maps
  local whichkey_exists, wk = pcall(require, "which-key")

  if whichkey_exists then
    set_maps = function(keybind, mapping_info, opts)
      wk.register({ [keybind] = mapping_info }, opts)
    end
  else
    set_maps = function(keybind, mapping_info, opts)
      local mode = opts.mode
      opts.mode = nil
      vim.keymap.set(mode, keybind, mapping_info[1], opts)
    end
  end

  mappings = mappings or vim.deepcopy(M.load_config().mappings)
  mappings.lspconfig = nil

  for _, section in pairs(mappings) do
    for mode, mode_values in pairs(section) do
      for keybind, mapping_info in pairs(mode_values) do
        -- merge default + user opts
        local default_opts = merge_tb("force", { mode = mode }, mapping_opt or {})
        local opts = merge_tb("force", default_opts, mapping_info.opts or {})

        if mapping_info.opts then
          mapping_info.opts = nil
        end

        set_maps(keybind, mapping_info, opts)
      end
    end
  end
end

-- remove plugins defined in chadrc
M.remove_default_plugins = function(plugins)
  local removals = M.load_config().plugins.remove or {}

  if not vim.tbl_isempty(removals) then
    for _, plugin in pairs(removals) do
      plugins[plugin] = nil
    end
  end

  return plugins
end

-- merge default/user plugin tables
M.merge_plugins = function(default_plugins)
  local user_plugins = M.load_config().plugins.user

  -- merge default + user plugin table
  default_plugins = merge_tb("force", default_plugins, user_plugins)

  local final_table = {}

  for key, _ in pairs(default_plugins) do
    default_plugins[key][1] = key
    final_table[#final_table + 1] = default_plugins[key]
  end

  return final_table
end

M.load_override = function(default_table, plugin_name)
  local user_table = M.load_config().plugins.override[plugin_name] or {}
  user_table = type(user_table) == "table" and user_table or user_table()
  return merge_tb("force", default_table, user_table)
end

M.toggle_folding = function()
  -- manual – folds must be defined by entering commands (such as zf)
  -- indent – groups of lines with the same indent form a fold
  -- syntax – folds are defined by syntax highlighting
  -- expr – folds are defined by a user-defined expression
  -- marker – special characters can be manually or automatically added to your text to flag the start and end of folds
  -- diff – used to fold unchanged text when viewing differences (automatically set in diff mode)
  --
  -- test {{{
    -- qqrq
  -- test }}}


  if vim.opt.foldmethod:get() == "marker" then
    vim.cmd("setlocal foldmethod=expr foldexpr=nvim_treesitter#foldexpr()")
    vim.notify("folding by TreeSitter")
  else
    vim.cmd("setlocal foldmethod=marker")
    vim.notify("folding by markers")
  end
end

return M
