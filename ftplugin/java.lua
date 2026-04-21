local ok, jdtls = pcall(require, "jdtls")
if not ok then
  return
end

local bufname = vim.api.nvim_buf_get_name(0)
local root_dir = vim.fs.root(bufname, {
  ".git",
  "mvnw",
  "gradlew",
  "pom.xml",
  "build.gradle",
  "build.gradle.kts",
})

if not root_dir then
  return
end

local workspace_dir = vim.fs.joinpath(vim.fn.stdpath "data", "jdtls-workspace", vim.fs.basename(root_dir))

jdtls.start_or_attach {
  cmd = { "jdtls", "-data", workspace_dir },
  root_dir = root_dir,
  handlers = {
    ["language/status"] = function(_, _) end,
    ["$/progress"] = function() end,
  },
}
