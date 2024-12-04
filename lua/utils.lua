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

-- Utility function to get the block code and determine the executable
function get_block_and_executable()
  local start_line, end_line, executable

  -- Check if visually selected
  if vim.fn.mode() == "v" or vim.fn.mode() == "V" then
    -- Get visual selection range
    start_line = vim.fn.line "'<"
    end_line = vim.fn.line "'>"
  else
    -- Detect block where the cursor is located
    local cursor_line = vim.fn.line "."
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

    -- Find the ``` line above the cursor
    for i = cursor_line - 1, 0, -1 do
      if lines[i]:match "^```" then
        start_line = i + 1
        executable = lines[i]:match "^```(%S+)"
        break
      end
    end

    -- Find the ``` line below the cursor
    for i = cursor_line, #lines do
      if lines[i]:match "^```" then
        end_line = i - 1
        break
      end
    end
  end

  -- Ensure executable and block lines are found
  if not executable then
    print "No executable detected in block."
    return nil, nil, nil
  end
  if not start_line or not end_line then
    print "Could not find complete ``` block."
    return nil, nil, nil
  end

  -- Get the block code
  local block_lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  local block_code = table.concat(block_lines, "\n")

  return block_code, executable, start_line
end

-- Function to execute block code
M.run_block_in_terminal_split = function(split_type)
  -- Default to horizontal split if no type is provided
  split_type = split_type or "horizontal"

  -- Get the block code and executable
  local block_code, executable = get_block_and_executable()
  if not block_code or not executable then
    return
  end

  -- Open the specified split type with a terminal
  if split_type == "vertical" then
    vim.cmd "vsplit | terminal"
  else
    vim.cmd "split | terminal"
  end

  -- Run the block code using the executable
  vim.fn.chansend(vim.b.terminal_job_id, executable .. " <<EOF\n" .. block_code .. "\nEOF\n")

  -- Set focus back to the previous window (optional)
  vim.cmd "wincmd p"
end

M.run_block_in_buffer_split = function(split_type)
  -- Default to horizontal split if no type is provided
  split_type = split_type or "horizontal"

  -- Get the block code and executable
  local block_code, executable = get_block_and_executable()
  if not block_code or not executable then
    return
  end

  -- Run the block code using the executable
  local handle = io.popen(executable .. " <<EOF\n" .. block_code .. "\nEOF")
  local output = handle:read "*a"
  handle:close()

  -- Open the specified split type
  if split_type == "vertical" then
    vim.cmd "vsplit"
  else
    vim.cmd "split"
  end

  -- Create a new buffer and display the output
  local buf = vim.api.nvim_create_buf(false, true) -- Create an unlisted, scratch buffer
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(output, "\n")) -- Set the output lines
  vim.api.nvim_buf_set_option(buf, "modifiable", false) -- Make buffer readonly
  vim.api.nvim_buf_set_option(buf, "buftype", "nofile") -- Mark as a scratch buffer

  -- Set the buffer to the current window
  vim.api.nvim_win_set_buf(0, buf)

  -- Set focus back to the previous window (optional)
  vim.cmd "wincmd p"
end
return M
