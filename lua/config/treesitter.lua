local parser_dir = vim.fn.stdpath("data") .. "/parser"
local uv = vim.loop

local function register_parsers_from_dir(dir)
  local handle = uv.fs_scandir(dir)
  if not handle then return end

  while true do
    local name, type = uv.fs_scandir_next(handle)
    if not name then break end

    if type == "file" and name:match("%.so$") then
      local lang = name:gsub("%.so$", "")
      local path = dir .. "/" .. name
      vim.treesitter.language.register(lang, path)
      vim.notify("🌳 Registered parser: " .. lang .. " → " .. path, vim.log.levels.DEBUG)
    end
  end
end

register_parsers_from_dir(parser_dir)


vim.cmd("syntax off")

-- Enable Tree-sitter on buffer enter
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    print("TS")
    pcall(vim.treesitter.start, 0)
  end,
})
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
