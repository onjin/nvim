local M = {}
-- Run the current file with the executable interpreter
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
