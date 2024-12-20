M = {}
M.trim = function(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

M.load_ini_file = function(file)
  local variables = {}
  for line in io.lines(file) do
    local key, value = line:match "^(.-)%s*=%s*(.-)%s*$"
    if key and value then
      key = M.trim(key)
      value = M.trim(value)
      if value:match "^'.*'$" or value:match '^".*"$' then
        value = value:sub(2, -2) -- Remove quotes
      elseif tonumber(value) then
        value = tonumber(value)
      end
      variables[key] = value
    end
  end
  return variables
end

M.set_global_variables = function(variables)
  for key, value in pairs(variables) do
    vim.g[key] = value
  end
end

M.set_globals_from_ini = function(filename)
  local ini_file = vim.fn.getcwd() .. "/" .. filename
  if vim.fn.filereadable(ini_file) == 1 then
    local variables = M.load_ini_file(ini_file)
    M.set_global_variables(variables)
  end
end

M.run_current_file_in_split = function(executable, split_type)
  -- Default executable to lua
  executable = executable or "lua"

  -- Default to vertical split if no type is provided
  split_type = split_type or "horizontal"

  -- Get the current file path
  local file_path = vim.fn.expand "%:p"
  if file_path == "" then
    print "No file to run."
    return
  end

  -- Open the specified split type with a terminal
  if split_type == "vertical" then
    vim.cmd "vsplit | terminal"
  else
    vim.cmd "split | terminal"
  end

  -- Send the executable interpreter command to the terminal
  local result_command = executable .. " " .. vim.fn.shellescape(file_path)
  vim.fn.chansend(vim.b.terminal_job_id, result_command .. "\n")

  -- Set the focus back to the previous window (optional)
  vim.cmd "wincmd p"
end

return M
