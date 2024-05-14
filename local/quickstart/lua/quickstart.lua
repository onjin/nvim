local quickstart = {}

local if_nil = vim.F.if_nil

local function should_skip_quickstart()
  -- don't start when opening a file
  if vim.fn.argc() > 0 then
    return true
  end

  -- skip stdin
  if vim.fn.line2byte "$" ~= -1 then
    return true
  end

  -- Handle nvim -M
  if not vim.o.modifiable then
    return true
  end

  for _, arg in pairs(vim.v.argv) do
    -- whitelisted arguments
    -- always open
    if arg == "--startuptime" then
      return false
    end

    -- blacklisted arguments
    -- always skip
    if
      arg == "-b"
      -- commands, typically used for scripting
      or arg == "-c"
      or vim.startswith(arg, "+")
      or arg == "-S"
    then
      return true
    end
  end

  -- base case: don't skip
  return false
end

function quickstart.start(on_vimenter, config)
  local window = vim.api.nvim_get_current_win()

  local buffer
  if on_vimenter then
    if should_skip_quickstart() then
      return
    end
    buffer = vim.api.nvim_get_current_buf()
  else
    if vim.bo.ft ~= "quickstart" then
      buffer = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_win_set_buf(window, buffer)
    else
      buffer = vim.api.nvim_get_current_buf()
      vim.api.nvim_buf_delete(buffer, {})
      return
    end
  end
  vim.notify "quickstart started"
end

function quickstart.setup(config)
  vim.validate {
    config = { config, "table" },
  }
  config.opts = vim.tbl_extend("keep", if_nil(config.opts, {}), { autostart = true })
  quickstart.default_config = config

  local group_id = vim.api.nvim_create_augroup("quickstart_start", { clear = true })
  vim.api.nvim_create_autocmd("VimEnter", {
    group = group_id,
    pattern = "*",
    nested = true,
    callback = function()
      if config.opts.autostart then
        quickstart.start(true, config)
      end
    end,
  })
end

return quickstart
