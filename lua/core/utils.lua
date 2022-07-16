local M = {}

local merge_tb = vim.tbl_deep_extend


M.load_config = function()
   local config = require "core.default_config"
   local chadrc_exists, chadrc = pcall(require, "custom.chadrc")

   if chadrc_exists then
      -- merge user config if it exists and is a table; otherwise display an error
      if type(chadrc) == "table" then
         M.remove_default_keys()
         config = merge_tb("force", config, chadrc)
      else
         error "chadrc must return a table!"
      end
   end

   config.mappings.disabled = nil
   return config
end

M.remove_default_keys = function()
   local chadrc = require "custom.chadrc"
   local user_mappings = chadrc.mappings or {}
   local user_keys = {}
   local user_sections = vim.tbl_keys(user_mappings)

   -- push user_map keys in user_keys table
   for _, section in ipairs(user_sections) do
      user_keys = vim.tbl_deep_extend("force", user_keys, user_mappings[section])
   end

   local function disable_key(mode, keybind, mode_mapping)
      local keys_in_mode = vim.tbl_keys(user_keys[mode] or {})

      if vim.tbl_contains(keys_in_mode, keybind) then
         mode_mapping[keybind] = nil
      end
   end

   local default_mappings = require("core.default_config").mappings

   -- remove user_maps from default mapping table
   for _, section_mappings in pairs(default_mappings) do
      for mode, mode_mapping in pairs(section_mappings) do
         for keybind, _ in pairs(mode_mapping) do
            disable_key(mode, keybind, mode_mapping)
         end
      end
   end
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

return M
