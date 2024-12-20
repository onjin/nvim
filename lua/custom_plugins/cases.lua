-- Lua module for case conversions
local M = {}

-- List of available cases for toggling
local available_cases = { "snake", "camel", "pascal" } -- do not use kebab in toggling, cause `-` is breaking getting back from
local current_case_index = 1 -- Tracks the current case index for toggling

-- Helper functions for different cases
local function to_snake_case(word)
  return word:gsub("(%l)(%u)", "%1_%2"):gsub("-", "_"):lower()
end

local function to_camel_case(word)
  word = word:gsub("[-_](%l)", string.upper):gsub("^%l", string.lower)
  return word
end

local function to_pascal_case(word)
  return word:gsub("[-_](%l)", string.upper):gsub("^%l", string.upper)
end

local function to_kebab_case(word)
  return word:gsub("(%l)(%u)", "%1-%2"):gsub("_", "-"):lower()
end

-- Convert the current word to the specified case
M.convert_case = function(target_case)
  local current_word = vim.fn.expand "<cword>" -- Get the word under the cursor

  -- Apply the conversion based on the target case
  local new_word
  if target_case == "snake" then
    new_word = to_snake_case(current_word)
  elseif target_case == "camel" then
    new_word = to_camel_case(current_word)
  elseif target_case == "pascal" then
    new_word = to_pascal_case(current_word)
  elseif target_case == "kebab" then
    new_word = to_kebab_case(current_word)
  else
    print("Unsupported case: " .. target_case)
    return
  end

  -- Replace the current word with the converted word
  local line = vim.fn.getline "."
  local new_line = line:gsub("%f[%w]" .. vim.pesc(current_word) .. "%f[%W]", new_word, 1)
  vim.fn.setline(".", new_line)
end

-- Toggle through available cases
M.toggle_case = function()
  -- Determine the next case in the loop
  current_case_index = (current_case_index % #available_cases) + 1
  local target_case = available_cases[current_case_index]

  -- Convert and update the word
  M.convert_case(target_case)
  print("Converted to " .. target_case .. " case")
end

-- Usage:
-- :lua require('cases').convert_case('snake') -- Convert to specified case
-- :lua require('cases').toggle_case() -- Toggle to the next case in the loop

return M
