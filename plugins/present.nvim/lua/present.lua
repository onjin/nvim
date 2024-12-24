local M = {}

M.setup = function()
  -- nothing
end

local state = {
  floating = {
    buf = -1,
    win = -1,
  },
}

local function create_floating_window(config)
  -- Create buffer
  local buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
  local win = vim.api.nvim_open_win(buf, true, config)
  return { buf = buf, win = win }
end

---@class present.Slides
---@field slides present.Slide[]: The slides from file

---@class present.Slide
---@field title string: The title of the slide
---@field body string[]: The body of the slide

--- Takes a list of lines and returns a list of slides
---@param lines string[]: The lines of the buffer
---@return present.Slides
local parse_slides = function(lines)
  local slides = { slides = {} }
  local current_slide = {
    title = "",
    body = {},
  }

  local separator = "^#"

  for _, line in ipairs(lines) do
    if line:find(separator) then
      if #current_slide.title > 0 then
        table.insert(slides.slides, current_slide)
      end
      current_slide = {
        title = line,
        body = {},
      }
    else
      table.insert(current_slide.body, line)
    end
    table.insert(current_slide, line)
  end
  table.insert(slides.slides, current_slide)
  return slides
end

---@class present.WindowConfiguration
---@field background vim.api.keyset.win_config: The background window configuration
---@field header vim.api.keyset.win_config: The header window configuration
---@field body vim.api.keyset.win_config: The body window configuration
---
--- Create windows configuration
---@return present.WindowConfiguration
local create_window_configuration = function()
  local width = vim.o.columns
  local height = vim.o.lines

  return {
    background = {
      relative = "editor",
      width = width,
      height = height,
      style = "minimal",
      col = 0,
      row = 0,
      zindex = 1,
    },
    header = {
      relative = "editor",
      width = width,
      height = 1,
      style = "minimal",
      col = 0,
      row = 0,
      border = "rounded",
      zindex = 2,
    },
    body = {
      relative = "editor",
      width = width - 8,
      height = height - 5,
      style = "minimal",
      col = 8,
      row = 4,
    },
  }
end

M.start_presentation = function(opts)
  opts = opts or {}
  opts.bufnr = opts.bufnr or 0
  local lines = vim.api.nvim_buf_get_lines(opts.bufnr, 0, -1, false)
  local parsed = parse_slides(lines)
  local current_slide = 1

  local windows = create_window_configuration()

  local background = create_floating_window(windows.background)
  local header = create_floating_window(windows.header)
  local body = create_floating_window(windows.body)
  vim.bo[header.buf].filetype = "markdown"
  vim.bo[body.buf].filetype = "markdown"

  local set_slide_content = function(idx)
    local width = vim.o.columns
    local slide = parsed.slides[idx]
    local padding = string.rep(" ", (width - #slide.title) / 2)
    local title = padding .. slide.title
    vim.api.nvim_buf_set_lines(header.buf, 0, -1, false, { title })
    vim.api.nvim_buf_set_lines(body.buf, 0, -1, false, slide.body)
  end

  set_slide_content(current_slide)

  vim.keymap.set("n", "n", function()
    current_slide = math.min(current_slide + 1, #parsed.slides)
    set_slide_content(current_slide)
  end, { buffer = body.buf })
  vim.keymap.set("n", "p", function()
    current_slide = math.max(current_slide - 1, 1)
    set_slide_content(current_slide)
  end, { buffer = body.buf })
  vim.keymap.set("n", "q", function()
    vim.api.nvim_win_close(body.win, true)
  end, { buffer = body.buf })

  local restore = {
    cmdheight = {
      original = vim.o.cmdheight,
      present = 0,
    },
  }

  for option, config in pairs(restore) do
    vim.opt[option] = config.present
  end

  vim.api.nvim_create_autocmd("BufLeave", {
    buffer = body.buf,
    callback = function()
      for option, config in pairs(restore) do
        vim.opt[option] = config.original
      end
      pcall(vim.api.nvim_win_close, background.win, true)
      pcall(vim.api.nvim_win_close, header.win, true)
    end,
  })
  vim.api.nvim_create_autocmd("VimResized", {
    group = vim.api.nvim_create_augroup("present-resized", {}),
    callback = function()
      if not vim.api.nvim_win_is_valid(body.win) or body.win == nil then
        return
      end

      local updated = create_window_configuration()
      vim.api.nvim_win_set_config(background.win, updated.background)
      vim.api.nvim_win_set_config(header.win, updated.header)
      vim.api.nvim_win_set_config(body.win, updated.body)
      set_slide_content(current_slide)
    end,
  })
end

return M
