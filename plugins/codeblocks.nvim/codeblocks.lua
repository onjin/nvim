-- [[
-- Allows to run markdown codeblocks like ```python ... ``` in readonly buffer or terminal split.
-- Focus is set back to the previous window.
-- You can close all side windows by f.e. Ctrl + W + o (:on :only).
--
-- Example mappings:
--
-- set(
--   "n",
--   "<localleader>x",
--   ":lua require('codeblocks').run_block('vertical')<CR>",
--   { desc = "Run code block in vertical buffer split", noremap = true, silent = true }
-- )
-- set(
--   "n",
--   "<localleader>t",
--   ":lua require('codeblocks').run_block('vertical', 'terminal')<CR>",
--   { desc = "Run code block in vertical terminal split", noremap = true, silent = true }
-- )
--
-- ]]
-- Define the module table
local M = {}

-- Define executors for specific block types
local executors = {
  lua = function(code)
    return "lua <<EOF\n" .. code .. "\nEOF"
  end,
  go = function(code)
    local tmpfile = vim.fn.tempname() .. ".go"
    local file = io.open(tmpfile, "w")
    file:write(code)
    file:close()
    return "go run " .. tmpfile
  end,
  python = function(code)
    return "python3 <<EOF\n" .. code .. "\nEOF"
  end,
  bash = function(code)
    return "bash <<EOF\n" .. code .. "\nEOF"
  end,
  typescript = function(code)
    return "tsx <<EOF\n" .. code .. "\nEOF"
  end,
  -- Add more executors as needed
}

-- Utility function to get the block code and determine the executable
local function get_block_and_executable()
  local start_line, end_line, block_type

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
        block_type = lines[i]:match "^```(%S+)"
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

  -- Ensure block type and lines are found
  if not block_type then
    print "No block type detected in ``` block."
    return nil, nil, nil
  end
  if not start_line or not end_line then
    print "Could not find complete ``` block."
    return nil, nil, nil
  end

  -- Get the block code
  local block_lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  local block_code = table.concat(block_lines, "\n")

  return block_code, block_type, start_line
end

-- Function to execute block code and display the result
-- `output_type` can be "buffer" (readonly buffer) or "terminal" (terminal split)
function M.run_block(split_type, output_type)
  -- Default to horizontal split and buffer output if not provided
  split_type = split_type or "horizontal"
  output_type = output_type or "buffer"

  -- Get the block code and block type
  local block_code, block_type = get_block_and_executable()
  if not block_code or not block_type then
    return
  end

  -- Get the executor for the block type or use default behavior
  local executor = executors[block_type]
  local command
  if executor then
    command = executor(block_code)
  else
    command = block_type .. " <<EOF\n" .. block_code .. "\nEOF"
  end

  if output_type == "terminal" then
    -- Open the specified split type with a terminal
    if split_type == "vertical" then
      vim.cmd "vsplit | terminal"
    else
      vim.cmd "split | terminal"
    end
    -- Send the command to the terminal
    vim.fn.chansend(vim.b.terminal_job_id, command .. "\n")
  else
    -- Run the command and capture the output
    local handle = io.popen(command)
    local output = handle:read "*a"
    handle:close()

    -- Open the specified split type
    if split_type == "vertical" then
      vim.cmd "vsplit"
    else
      vim.cmd "split"
    end

    -- Create a new buffer and display the output
    local buf = vim.api.nvim_create_buf(false, true)                       -- Create an unlisted, scratch buffer
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(output, "\n")) -- Set the output lines
    vim.api.nvim_buf_set_option(buf, "modifiable", false)                  -- Make buffer readonly
    vim.api.nvim_buf_set_option(buf, "buftype", "nofile")                  -- Mark as a scratch buffer

    -- Set the buffer to the current window
    vim.api.nvim_win_set_buf(0, buf)
  end

  -- Set focus back to the previous window (optional)
  vim.cmd "wincmd p"
end

return M
