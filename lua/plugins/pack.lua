local M = {}

local hooks = {}
local registered = false

local function infer_name(src)
  local name = src:match("/([^/]+)%.git$") or src:match("/([^/]+)$")
  assert(name, "Cannot infer plugin name from source: " .. src)
  return name
end

local function plugin_name(spec)
  if type(spec) == "string" then
    return infer_name(spec)
  end
  return spec.name or infer_name(spec.src)
end

local function ensure_autocmd()
  if registered then
    return
  end
  registered = true

  vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
      local plugin_hooks = hooks[ev.data.spec.name]
      if not plugin_hooks then
        return
      end

      local hook = plugin_hooks[ev.data.kind]
      if hook then
        hook(ev)
      end
    end,
  })
end

function M.add(specs, opts)
  ensure_autocmd()

  local pack_specs = {}

  for _, original in ipairs(specs) do
    if type(original) == "string" then
      table.insert(pack_specs, original)
    else
      local spec = vim.deepcopy(original)
      local name = plugin_name(spec)
      local plugin_hooks = {
        install = spec.install_hook,
        update = spec.update_hook,
        delete = spec.delete_hook,
      }

      spec.install_hook = nil
      spec.update_hook = nil
      spec.delete_hook = nil
      spec.confirm = nil

      if plugin_hooks.install or plugin_hooks.update or plugin_hooks.delete then
        hooks[name] = plugin_hooks
      end

      table.insert(pack_specs, spec)
    end
  end

  opts = vim.tbl_extend("force", { confirm = false }, opts or {})
  return vim.pack.add(pack_specs, opts)
end

return M
